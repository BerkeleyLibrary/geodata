require 'rails_helper'
require 'zip'
require 'fileutils'
# require_relative '../support/link_spec'

RSpec.describe 'File Download' do
  let(:download_dir) { '/opt/app/tmp/cache/downloads' }

  before do
    FileUtils.mkdir_p(download_dir)
    visit_public_record
    click_download_button
  end

  it_behaves_like 'export geofile to local', 'berkeley-s7038h-shapefile.zip', 'Export Shapefile'
  it_behaves_like 'export geofile to local',  'berkeley-s7038h-kmz.kmz', 'Export KMZ'
  it_behaves_like 'export geofile to local',  'berkeley-s7038h-geojson.json', 'Export GeoJSON'

end
