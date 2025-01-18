require 'rails_helper'
require 'zip'
require 'fileutils'

RSpec.describe 'Export links from download section' do

  before do
    view_public_record
    click_download_button
  end

  it_behaves_like 'export geofile to local', 'berkeley-s7038h-shapefile.zip', 'Export Shapefile'
  it_behaves_like 'export geofile to local',  'berkeley-s7038h-kmz.kmz', 'Export KMZ'
  it_behaves_like 'export geofile to local',  'berkeley-s7038h-geojson.json', 'Export GeoJSON'

end
