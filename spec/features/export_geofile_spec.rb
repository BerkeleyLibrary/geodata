require 'rails_helper'
require 'zip'
require 'fileutils'

RSpec.describe 'File Download' do
  let(:download_dir) { '/opt/app/tmp/cache/downloads' }
  let(:shapefile_zip_file_name) { 'berkeley-s7038h-shapefile.zip' }
  let(:shapefile_zip_file_path) { File.join(download_dir, shapefile_zip_file_name) }

  before do
    # FileUtils.rm_f(shapefile_zip_file_path)
    Dir.mkdir(download_dir) unless File.exist?(download_dir)
    # FileUtils.rm_f(shapefile_zip_file_path)
    # FileUtils.mkdir_p(download_dir)
    visit 'catalog/berkeley-s7038h'
  end

  after do
    # FileUtils.rm_f(zip_file_path)
    FileUtils.rm_f(shapefile_zip_file_path)
  end

  context 'export geo files' do
    before do
      find('#downloads-button').click
    end
    it 'displays the download button' do
      find_link('Export Shapefile').click
      sleep 5
      expect(File.exist?(shapefile_zip_file_path)).to be_truthy, "Expected source data zip file not found: #{shapefile_zip_file_path}"
      # sleep(500)
    end

  end
end
