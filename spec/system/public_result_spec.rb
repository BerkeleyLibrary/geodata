require 'rails_helper'

RSpec.describe 'View Search Reslut' do
  before do
    view_public_record
  end

  it 'has correct record title' do
    within('#document') do
      expect(find('h2')).to have_text('Intersections, San Benito County, California, 2016')
    end
  end

  context 'metadata link' do
    it 'displays the metadata link' do
      expect(page).to have_link('Metadata', href: "/catalog/#{CommonHelpers::PUBLIC_RECORD_ID}/metadata")
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

  context 'downloading button' do
    it 'displays the download button' do
      expect(page).to have_button('downloads-button')
    end

    it_behaves_like 'download link invisible', 'Original Shapefile'
    it_behaves_like 'download link invisible', 'Export Shapefile'
    it_behaves_like 'download link invisible', 'Export KMZ'
    it_behaves_like 'download link invisible', 'Export GeoJSON'

  end

end
