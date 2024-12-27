require 'rails_helper'

RSpec.describe 'View Search Reslut' do
  before do
    visit 'catalog/berkeley-s7038h'
  end

  it 'has the record title' do
    within('#document') do
      expect(find('h2')).to have_text('Intersections, San Benito County, California, 2016')
    end
  end

  it 'displays the metadata link' do
    expect(page).to have_link('Metadata', href: '/catalog/berkeley-s7038h/metadata')
  end

  context 'when clicking the metadata link' do
    it 'triggers the modal', js: true do
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

  context 'when downloading geodata' do
    it 'displays the download button' do
      expect(page).to have_button('downloads-button')
    end

    it 'clicking to show downloading options' do
      find('#downloads-button').click
      expect(page).to have_link(text: 'Original Shapefile', href: 'https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip')
      expect(page).to have_css('a[contenturl="https://spatial.lib.berkeley.edu/public/berkeley-s7038h/data.zip"]')
      expect(page).to have_css('a[data-download="trigger"]')
      expect(page).to have_css('a[data-download-type="direct"]')
      expect(page).to have_css('a[data-download-id="berkeley-s7038h"]')

      expect(page).to have_link(text: 'Export Shapefile', href: '')
      # expect(page).to have_link(text: 'Export KMZ')
      # expect(page).to have_link(text: 'Export GeoJSON')
      #
      find('a[data-download-type="direct"]').click
      # expect(File).to exist('/tmp/data.zip')
      expect(find('a[data-download-type="direct"]').text).to eq('Original Shapefile')
    end
  end
end
