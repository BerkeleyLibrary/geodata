require 'rails_helper'
require 'zip'
require 'fileutils'
require_relative '../support/shared_examples/link_spec'

RSpec.describe 'File Download' do
  # let(:download_dir) { '/opt/app/tmp/cache/downloads' }

  # before do
  #   Dir.mkdir(download_dir) unless File.exist?(download_dir)
  #   visit 'catalog/berkeley-s7038h'
  #   find('#downloads-button').click
  # end

  it_behaves_like 'export geofile',  'berkeley-s7038h-shapefile.zip', 'Export Shapefile'
  it_behaves_like 'export geofile',  'berkeley-s7038h-kmz.kmz', 'Export KMZ'
  it_behaves_like 'export geofile',  'berkeley-s7038h-geojson.json', 'Export GeoJSON'
  # after do
  #   # FileUtils.rm_f(zip_file_path)
  #   FileUtils.rm_f(shapefile_zip_file_path)
  # end

  # context 'export geo files' do
  #   before do
  #     find('#downloads-button').click
  #   end
  #   it 'displays the download button' do
  #     find_link('Export Shapefile').click
  #     sleep 5
  #     expect(File.exist?(shapefile_zip_file_path)).to be_truthy, "Expected source data zip file not found: #{shapefile_zip_file_path}"
  #     # sleep(500)
  #   end

  # end
end
