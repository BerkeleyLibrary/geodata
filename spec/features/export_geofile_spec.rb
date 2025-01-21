require 'rails_helper'
require 'zip'
require 'fileutils'

RSpec.describe 'Export links from download section' do

  before do
    view_record(CommonHelpers::PUBLIC_RECORD_ID)
    click_download_button
  end

  it_behaves_like 'export geofile to local', "#{CommonHelpers::PUBLIC_RECORD_ID}-shapefile.zip", 'Export Shapefile'
  it_behaves_like 'export geofile to local',  "#{CommonHelpers::PUBLIC_RECORD_ID}-kmz.kmz", 'Export KMZ'
  it_behaves_like 'export geofile to local',  "#{CommonHelpers::PUBLIC_RECORD_ID}-geojson.json", 'Export GeoJSON'

end
