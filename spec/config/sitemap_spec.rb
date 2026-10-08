require 'spec_helper'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object/blank'
require 'sitemap_generator'
require 'rsolr'
require 'tmpdir'
require 'zlib'
require 'rexml/document'

RSpec.describe 'Catalog sitemap' do
  let(:base_url) { 'https://geodata.example.org' }
  let(:id_field) { 'id' }
  let(:modified_field) { 'gbl_mdModified_dt' }
  let(:solr) { instance_double(RSolr::Client) }
  let(:documents) do
    [
      { id_field => 'stanford-cf150bq6175', modified_field => '2024-06-13T04:51:22Z', 'timestamp' => '2026-07-15T21:25:12.100Z' },
      { id_field => 'berkeley-s7z97w', modified_field => '2018-03-26T23:34:35.206Z', 'timestamp' => '2026-07-15T21:29:58.056Z' },
      { id_field => 'missing-modification-date', 'timestamp' => '2026-07-15T21:29:58.056Z' },
      { id_field => 'blank-modification-date', modified_field => '' }
    ]
  end

  around do |example|
    Dir.mktmpdir('geodata-sitemap') do |directory|
      @sitemap_directory = directory
      example.run
    end
  end

  before do
    configuration = double('configuration', x: double('x', sitemap: double('sitemap settings', base_url: base_url)))
    stub_const('Rails', double('Rails', configuration: configuration))
    stub_const('Blacklight', double('Blacklight', connection_config: { url: 'http://solr.example.org' }))
    stub_const('Settings', double('Settings', FIELDS: double('fields', ID: id_field, MODIFIED: modified_field)))
    stub_const('SitemapGenerator::Sitemap', SitemapGenerator::LinkSet.new(public_path: @sitemap_directory, verbose: false))
    allow(RSolr).to receive(:connect).with(url: 'http://solr.example.org').and_return(solr)
    allow(solr).to receive(:get).with('select', params: { q: '*:*', fl: "#{id_field},#{modified_field}", rows: 1_000, sort: "#{id_field} asc", cursorMark: '*' }).and_return('response' => { 'docs' => documents.sort_by { |document| document[id_field] } }, 'nextCursorMark' => 'after-documents')
    allow(solr).to receive(:get).with('select', params: { q: '*:*', fl: "#{id_field},#{modified_field}", rows: 1_000, sort: "#{id_field} asc", cursorMark: 'after-documents' }).and_return('response' => { 'docs' => [] }, 'nextCursorMark' => 'after-documents')
  end

  def catalog_entries
    load File.expand_path('../../config/sitemap.rb', __dir__)
    xml = Zlib::GzipReader.open(File.join(@sitemap_directory, 'sitemap.xml.gz'), &:read)
    REXML::Document.new(xml).root.elements.to_a('url').select { |entry| entry.elements['loc'].text.include?('/catalog/') }
  end

  it 'writes each metadata modification date to the corresponding catalog URL' do
    entries = catalog_entries.to_h { |entry| [entry.elements['loc'].text, entry.elements['lastmod']&.text] }

    expect(entries["#{base_url}/catalog/stanford-cf150bq6175"]).to eq('2024-06-13T04:51:22Z')
    expect(entries["#{base_url}/catalog/berkeley-s7z97w"]).to eq('2018-03-26T23:34:35.206Z')
    expect(entries.keys).to eq(documents.map { |document| "#{base_url}/catalog/#{document[id_field]}" }.sort)
  end

  context 'with a custom MODIFIED field' do
    let(:modified_field) { 'custom_modified_dt' }

    it 'requests the configured field and uses its date for lastmod' do
      entries = catalog_entries.index_by { |entry| entry.elements['loc'].text }

      expect(entries.fetch("#{base_url}/catalog/stanford-cf150bq6175").elements['lastmod'].text).to eq('2024-06-13T04:51:22Z')
      expect(entries.fetch("#{base_url}/catalog/berkeley-s7z97w").elements['lastmod'].text).to eq('2018-03-26T23:34:35.206Z')
    end
  end

  context 'with a custom ID field' do
    let(:id_field) { 'custom_id_s' }

    it 'requests and sorts by the configured field and uses its value for catalog URLs' do
      entries = catalog_entries.map { |entry| entry.elements['loc'].text }

      expected = [
        "#{base_url}/catalog/berkeley-s7z97w",
        "#{base_url}/catalog/blank-modification-date",
        "#{base_url}/catalog/missing-modification-date",
        "#{base_url}/catalog/stanford-cf150bq6175"
      ]
      expect(entries).to eq(expected)
    end
  end

  it 'keeps records without modification dates in the sitemap without inventing lastmod values' do
    entries = catalog_entries.index_by { |entry| entry.elements['loc'].text }

    expect(entries.fetch("#{base_url}/catalog/missing-modification-date").elements['lastmod']&.text).to eq '2026-09-01'
    expect(entries.fetch("#{base_url}/catalog/blank-modification-date").elements['lastmod']&.text).to eq '2026-09-01'
  end

  it 'preserves catalog entries when the sitemap is regenerated' do
    original = catalog_entries.map(&:to_s)

    expect(catalog_entries.map(&:to_s)).to eq(original)
  end

  it 'retrieves multiple batches in cursor order and includes the final partial batch exactly once' do
    documents = Array.new(2_001) { |index| { id_field => format('record-%04d', index), modified_field => '2024-06-13T04:51:22Z' } }
    pages = {
      '*' => { 'response' => { 'docs' => documents.first(1_000) }, 'nextCursorMark' => 'page-2' },
      'page-2' => { 'response' => { 'docs' => documents.slice(1_000, 1_000) }, 'nextCursorMark' => 'page-3' },
      'page-3' => { 'response' => { 'docs' => documents.last(1) }, 'nextCursorMark' => 'finished' },
      'finished' => { 'response' => { 'docs' => [] }, 'nextCursorMark' => 'finished' }
    }
    cursors = []
    allow(solr).to receive(:get).with('select', params: hash_including(q: '*:*', fl: "#{id_field},#{modified_field}", rows: 1_000, sort: "#{id_field} asc")) do |_, arguments|
      cursor = arguments.fetch(:params).fetch(:cursorMark)
      cursors << cursor
      pages.fetch(cursor)
    end

    entries = catalog_entries

    expect(cursors).to eq(%w[* page-2 page-3 finished])
    expect(entries.map { |entry| entry.elements['loc'].text }).to eq(documents.map { |document| "#{base_url}/catalog/#{document[id_field]}" })
    expect(entries.map { |entry| entry.elements['lastmod'].text }.uniq).to eq(['2024-06-13T04:51:22Z'])
  end

  it 'stops immediately for an empty index' do
    allow(solr).to receive(:get).with('select', params: { q: '*:*', fl: "#{id_field},#{modified_field}", rows: 1_000, sort: "#{id_field} asc", cursorMark: '*' }).and_return('response' => { 'docs' => [] }, 'nextCursorMark' => '*')

    expect(catalog_entries).to be_empty
    expect(solr).to have_received(:get).once
  end
end
