require 'rails_helper'

RSpec.describe 'View Search Result' do
  before do
    view_record(CommonHelpers::PUBLIC_RECORD_ID)
  end

  it 'has correct record title' do
    within('#document') do
      expect(page).to have_selector('h1', text: 'Intersections, San Benito County, California, 2016')
    end
  end

  context 'metadata button' do
    it 'displays the metadata button with its metadata URL' do
      expect(page).to have_css("button#metadataLink[data-modal-url='/catalog/#{CommonHelpers::PUBLIC_RECORD_ID}/metadata']", text: 'Metadata')
    end

    it 'clicking the metadata button triggers the modal', js: true do
      find('#metadataLink').click

      expect(page).to have_css('.metadata-view a.pill-metadata.nav-link', visible: true)
      find('a.pill-metadata.nav-link', text: 'ISO 19139', visible: true).click

      expect(page).to have_css('a.pill-metadata.nav-link.active',
                               text: 'ISO 19139',
                               visible: true)
      expect(page).to have_css('a.pill-metadata.nav-link.active[data-ref-endpoint="https://spatial.ucblib.org/maps/berkeley-ark28722-s7038h/metadata/iso19139.xml"]')
      expect(page).to have_css('a.pill-metadata.nav-link.active[data-bs-toggle="pill"]')
    end
  end

  context 'citation button' do
    it 'opens the citation modal', js: true do
      expect(page).to have_button('citationLink')

      find('#citationLink').click

      expect(page).to have_css('#blacklight-modal .modal-title', text: I18n.t('blacklight.tools.citation'))
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
