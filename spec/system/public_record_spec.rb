require 'rails_helper'
require_relative '../support/shared_examples/link_spec'

RSpec.describe 'View Search Reslut', type: :system do
  before do
    visit 'catalog/berkeley-s7038h'
  end

  # shared_examples 'download link invisible' do |text|
  #   it "it has no link #{text}" do
  #     expect(page).not_to have_link(text: text)
  #   end
  # end

  # shared_examples 'download link visible' do |text, href, css_downloads|
  #   it "it has link #{text}" do
  #     expect(page).to have_link(text: text, href: href)
  #   end
  #   it 'is has download css attributes' do
  #     expect(page).to have_css(css_downloads[:location])
  #     expect(page).to have_css(css_downloads[:style])
  #     expect(page).to have_css(css_downloads[:type])
  #     expect(page).to have_css(css_downloads[:id])
  #   end
  # end

  it 'has the record title' do
    within('#document') do
      expect(find('h2')).to have_text('Intersections, San Benito County, California, 2016')
    end
  end

  context 'has metadata link' do
    it 'displays the metadata link' do
      expect(page).to have_link('Metadata', href: '/catalog/berkeley-s7038h/metadata')
    end

    it 'clicking the metadata link, triggers the modal', js: true do
      find('#metadataLink').click

      expect(page).to have_css('a.pill-metadata.nav-link.active',
                               text: 'ISO 19139',
                               visible: true)

      expect(page).to have_css('a.pill-metadata.nav-link.active[data-ref-endpoint="https://spatial.lib.berkeley.edu/metadata/berkeley-s7038h/iso19139.xml"]')
      expect(page).to have_css('a.pill-metadata.nav-link.active[data-toggle="pill"]')
    end
  end

  context 'downloading button available' do
    it 'displays the download button' do
      expect(page).to have_button('downloads-button')
    end
    it_behaves_like 'download link invisible', 'Original Shapefile'
    it_behaves_like 'download link invisible', 'Export Shapefile'
    it_behaves_like 'download link invisible', 'Export KMZ'
    it_behaves_like 'download link invisible', 'Export GeoJSON'
  end

  context 'downloading links available' do
    before do
      find('#downloads-button').click
    end

    href = 'https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip'
    css_downloads = { location: 'a[contenturl="https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip"]',
                      style: 'a[data-download="trigger"]',
                      type: 'a[data-download-type="direct"]',
                      id: 'a[data-download-id="berkeley-s7038h"]' }
    it_behaves_like 'download link visible', 'Original Shapefile', href, css_downloads

    it_behaves_like 'download link from Geoserver invisible', 'Export Shapefile', 'shapefile', css_downloads

    # href = ''
    # # css_downloads[:location] = 'a[data-download-path="/download/berkeley-s7038h?type=shapefile"]'
    #                               "a[data-download-path=\"/download/bb-s7038h?type=shapefile\"]"
    # # css_downloads[:type] = 'a[data-download-type="shapefile"]'
    # # it_behaves_like 'download link visible', 'Export Shapefile', href, css_downloads

    # css_downloads[:location] = 'a[data-download-path="/download/berkeley-s7038h?type=kmz"]'
    # css_downloads[:type] = 'a[data-download-type="kmz"]'
    # it_behaves_like 'download link visible', 'Export KMZ', href, css_downloads

    # css_downloads[:location] = 'a[data-download-path="/download/berkeley-s7038h?type=geojson"]'
    # css_downloads[:type] = 'a[data-download-type="geojson"]'
    # it_behaves_like 'download link visible', 'Export GeoJSON', href, css_downloads
  end
end
