require 'rails_helper'
require_relative '../support/shared_examples/link_spec'

RSpec.describe 'View Search Reslut', type: :system do
  before do
    visit 'catalog/berkeley-s7038h'
  end

  shared_examples 'download link invisible' do |text|
    it "it has no link #{text}" do
      expect(page).not_to have_link(text: text)
    end
  end

  shared_examples 'download link visible' do |text, href, css_downloads|
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

    xit 'not triggers the modal' do
      find('#metadataLink').click
      expect(page).to have_current_path('/catalog/berkeley-s7038h/metadata')
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
  context 'clicking button to display downloading links' do
    before do
      find('#downloads-button').click
    end

    href = 'https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip'
    css_downloads = { location: 'a[contenturl="https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip"]',
                      style: 'a[data-download="trigger"]',
                      type: 'a[data-download-type="direct"]',
                      id: 'a[data-download-id="berkeley-s7038h"]' }
    it_behaves_like 'download link visible', 'Original Shapefile', href, css_downloads

    href = ''
    css_downloads = { location: 'a[data-download-path="/download/berkeley-s7038h?type=shapefile"]',
                      style: 'a[data-download="trigger"]',
                      type: 'a[data-download-type="shapefile"]',
                      id: 'a[data-download-id="berkeley-s7038h"]' }
    it_behaves_like 'download link visible', 'Export Shapefile', href, css_downloads

    css_downloads = { location: 'a[data-download-path="/download/berkeley-s7038h?type=kmz"]',
                      style: 'a[data-download="trigger"]',
                      type: 'a[data-download-type="kmz"]',
                      id: 'a[data-download-id="berkeley-s7038h"]' }
    it_behaves_like 'download link visible', 'Export KMZ', href, css_downloads

    css_downloads = { location: 'a[data-download-path="/download/berkeley-s7038h?type=geojson"]',
                      style: 'a[data-download="trigger"]',
                      type: 'a[data-download-type="geojson"]',
                      id: 'a[data-download-id="berkeley-s7038h"]' }
    it_behaves_like 'download link visible', 'Export GeoJSON', href, css_downloads

  end
  # end
end

# RSpec.shared_examples 'download link visible' do |page, text, href, css_downloads|
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

# RSpec.shared_examples 'download link invisible' do |page, text|
#   it "it has no link #{text}" do
#     expect(page).not_to have_link(text: text)
#   end

# end

# <a data-download-path="/download/berkeley-s7038h?type=kmz" data-download="trigger" data-download-type="kmz" data-download-id="berkeley-s7038h" href="">Export KMZ</a>

# it_behaves_like 'download link visible', page, 'Export Shapefile'
# it_behaves_like 'download link visible', page, 'Export KMZ'
# it_behaves_like 'download link visible', page, 'Export GeoJSON'

# expect(page).to have_link(text: 'Original Shapefile', href: 'https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip')
# expect(page).to have_css('a[contenturl="https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip"]')
# expect(page).to have_css('a[data-download="trigger"]')
# expect(page).to have_css('a[data-download-type="shapefile"]')
# expect(page).to have_css('a[data-download-id="berkeley-s7038h"]')

# expect(page).to have_link(text: 'Export Shapefile', href: '')
# # expect(page).to have_link(text: 'Export KMZ')
# expect(page).to have_link(text: 'Export GeoJSON')
#
# find('a[data-download-type="direct"]').click
# # expect(File).to exist('/tmp/data.zip')
# expect(find('a[data-download-type="direct"]').text).to eq('Original Shapefile')
# end

# <a data-download-path="/download/berkeley-s7038h?type=shapefile"
# data-download="trigger" data-download-type="shapefile"
# data-download-id="berkeley-s7038h"
#  href="">Export Shapefile</a>

# it 'clicking button to show downloading options' do
#   find('#downloads-button').click
#   expect(page).to have_link(text: 'Original Shapefile', href: 'https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip')
#   expect(page).to have_css('a[contenturl="https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip"]')
#   expect(page).to have_css('a[data-download="trigger"]')
#   expect(page).to have_css('a[data-download-type="direct"]')
#   expect(page).to have_css('a[data-download-id="berkeley-s7038h"]')

#   expect(page).to have_link(text: 'Export Shapefile', href: '')
#   # expect(page).to have_link(text: 'Export KMZ')
#   # expect(page).to have_link(text: 'Export GeoJSON')
#   #
#   find('a[data-download-type="direct"]').click
#   # expect(File).to exist('/tmp/data.zip')
#   expect(find('a[data-download-type="direct"]').text).to eq('Original Shapefile')
# end
