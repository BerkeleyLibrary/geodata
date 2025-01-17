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
    # visit 'catalog/berkeley-s7038h'
    visit_public_record
  end

  after(:each) do
    # clear_download_files
    # Capybara.reset_sessions!
    rm_files(all_files)
    # puts 'After callback executed -- dff'
  end

  # def clear_download_files
  #   crdownload_files.append(zip_file_path).compact.each { |f| FileUtils.rm_f(f) }
  # end

  # def wait_for_download(zip_file_path, timeout: 5)
  #   start_time = Time.current

  #   loop do
  #     elapsed_time = Time.current - start_time
  #     raise "Error: Timeout waiting for downloading #{zip_file_path}" if elapsed_time > timeout
  #     return true if File.exist?(zip_file_path)

  #     sleep 1
  #   end
  # rescue StandardError => e
  #   Rails.logger.error e.message
  #   false
  # end

  context 'verify original data.zip file' do
    before do
      click_download_button
      # find('#downloads-button').click
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
