require 'rails_helper'
require 'zip'
require 'fileutils'

RSpec.describe 'Data.zip File Download' do
  let(:download_dir) { '/opt/app/tmp/selenium_downloads' }
  let(:zip_file_name) { 'data.zip' }
  let(:zip_file_path) { File.join(download_dir, zip_file_name) }
  let(:zip_crdownload_file) { "#{zip_file_path}.crdownload" }
  let(:crdownload_files) { Dir.glob(File.join(download_dir, '*.crdownload')) }
  let(:all_files) { crdownload_files + [zip_file_path] }

  before do
    rm_files(all_files)
    visit_public_record
  end

  after(:each) do

    rm_files(all_files)

  end

  context 'verify original data.zip file' do
    before do
      click_download_button

    end
    it 'click link to download original source data zip file' do
      find_link('Original Shapefile').click
      download_completed = wait_for_download(zip_file_path)
      if download_completed
        expect(File.exist?(zip_file_path)).to be_truthy, "Error: Downloaded data.zip file not found: #{zip_file_path}"
        Zip::File.open(zip_file_path) do |zip_file|
          file_names = zip_file.map(&:name)
          expect(file_names).to include('SanBenito_Intersections_2016.shp'), 'Error: SanBenito_Intersections_2016.shp not found in data.zip'
        end
      else
        expect(File.exist?(zip_crdownload_file)).to be_truthy, "Error: Download not completed and incompleted data.zip.crdownload file found: #{zip_crdownload_file}"
        expect(File.size(zip_crdownload_file)).to be > 130_000, 'Error: Incompleted data.zip.crdownload file size <= 130000'
      end
    end
  end
end
