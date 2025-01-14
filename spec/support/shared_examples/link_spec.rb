RSpec.shared_examples 'download link visible' do |text, href, css_downloads|
  it "it has link #{text}" do
    expect(page).to have_link(text: text, href: href)
  end

  it 'is has download css attributes' do
    expect(page).to have_css(css_downloads[:location])
    expect(page).to have_css(css_downloads[:style])
    expect(page).to have_css(css_downloads[:type])
    expect(page).to have_css(css_downloads[:id])

  end
end

RSpec.shared_examples 'download link invisible' do |text|
  it "it has no link #{text}" do
    expect(page).not_to have_link(text: text)
  end

end

RSpec.shared_examples 'export geofile to local' do |file_name, link_name|
  let(:download_dir) { '/opt/app/tmp/cache/downloads' }
  let(:export_file_path) { File.join(download_dir, file_name) }

  before do
    # FileUtils.rm_f(shapefile_zip_file_path)
    FileUtils.mkdir_p(download_dir)
    # Dir.mkdir(download_dir) unless File.exist?(download_dir)
    # FileUtils.rm_f(shapefile_zip_file_path)
    # FileUtils.mkdir_p(download_dir)
    visit 'catalog/berkeley-s7038h'
    find('#downloads-button').click
  end

  after do
    # FileUtils.rm_f(zip_file_path)
    FileUtils.rm_f(export_file_path)
  end

  it "export geofle: #{file_name}" do
    find_link(link_name).click
    sleep 5
    expect(File.exist?(export_file_path)).to be_truthy, "Expected no exported geofile not found: #{export_file_path}"
  end

end
