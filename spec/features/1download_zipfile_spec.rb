require 'rails_helper'
require 'zip'
require 'fileutils'

RSpec.describe 'File Download', type: :feature do
  let(:download_dir) { '/home/seluser/Downloads' }
  let(:zip_file_name) { 'data.zip' }
  let(:zip_file_path) { File.join(download_dir, zip_file_name) }
  let(:crdownload_file) { "#{zip_file_path}.crdownload" }

  before do

    # Setup Selenium WebDriver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_preference(:download, default_directory: download_dir)
    options.add_preference(:download, prompt_for_download: false)
    options.add_preference(:safebrowsing, enabled: true)

    @driver = Selenium::WebDriver.for(:remote, url: 'http://selenium.test:4444/', capabilities: options)
    @driver.navigate.to 'http://app.test:3000/catalog/berkeley-s7038h'
    @driver.find_element(:id, 'downloads-button').click
    # FileUtils.rm_f(zip_file_path)
    # visit 'catalog/berkeley-s7038h'
  end

  after do
    FileUtils.rm_f(crdownload_file)
    FileUtils.rm_f(zip_file_path)
  end

  context 'verify souce data zip file' do
    # before do
    #   find('#downloads-button').click
    # end
    it 'click link to download original source data zip file' do
      @driver.find_link('Original Shapefile').click
      sleep 5

      # wait = Selenium::WebDriver::Wait.new(timeout: 30)
      # wait.until do
      #   !File.exist?(crdownload_file) && File.exist?(zip_file_path)
      # end
      expect(File.exist?(zip_file_path)).to be_truthy, "Expected souce data zip file not found: #{zip_file_path}"

    end

    # it 'Source data zip file includes ' do
    #   Zip::File.open(zip_file_path) do |zip_file|
    #     file_names = zip_file.map(&:name)
    #     puts "Contents: #{file_names}"
    #     expect(file_names).to include('SanBenito_Intersections_2016.shp')
    #   end
    # end

  end
end
