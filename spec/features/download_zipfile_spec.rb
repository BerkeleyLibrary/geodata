require 'rails_helper'
require 'zip'
require 'fileutils'

RSpec.describe 'File Download', type: :feature do
  let(:download_dir) { '/home/seluser/Downloads/' }
  let(:zip_file_name) { 'data.zip' }
  let(:zip_file_path) { File.join(download_dir, zip_file_name) }
  let(:crdownload_file) { "#{zip_file_path}.crdownload" }
  let(:crdownload_files) { Dir.glob(File.join(download_dir, '*.crdownload')) }

  before do

    # Setup Selenium WebDriver
    # options = Selenium::WebDriver::Chrome::Options.new
    # options.add_preference(:download, default_directory: download_dir)
    # options.add_preference(:download, prompt_for_download: false)
    # options.add_preference(:safebrowsing, enabled: true)

    # @driver = Selenium::WebDriver.for(:remote, url: 'http://selenium.test:4444/', capabilities: options)
    # @driver.navigate.to 'http://app.test:3000/catalog/berkeley-s7038h'
    # @driver.find_element(:id, '#downloads-button').click
    # FileUtils.rm_f(zip_file_path)
    visit 'catalog/berkeley-s7038h'
  end

  after do
    crdownload_files.each { |f| FileUtils.rm_f(f) }
    FileUtils.rm_f(zip_file_path)
  end

  def wait_for_zip_download(zip_file_path, timeout: 600)
    start_time = Time.current

    loop do
      elapsed_time = Time.current - start_time
      raise "Timeout waiting for #{zip_file_path}" if elapsed_time > timeout

      if File.exist?(zip_file_path) && crdownload_file.empty?
        puts "File #{zip_file_path} is fully downloaded."
        return true
      else
        sleep 1
      end
    end
  rescue StandardError => e
    puts "waiting Error: #{e.message}"
    false
  end

  context 'verify souce data zip file' do
    before do
      find('#downloads-button').click
    end
    it 'click link to download original source data zip file' do
      find_link('Original Shapefile').click
      sleep 10

      # wait = Selenium::WebDriver::Wait.new(timeout: 10)
      # wait.until do
      #   !File.exist?(crdownload_file) && File.exist?(zip_file_path)
      # end
      # wait_for_zip_download(zip_file_path, timeout: 5)
      expect(File.exist?(zip_file_path)).to be_truthy, "Expected source data zip file not found: #{zip_file_path}"
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
