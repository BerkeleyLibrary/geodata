module CommonHelpers
  EXPORT_TMP_PATH = '/opt/app/tmp/cache/downloads'.freeze
  DOWNLOAD_TMP_PATH = '/opt/app/tmp/selenium_downloads'.freeze
  PUBLIC_RECORD_ID = 'berkeley-s7038h'.freeze
  RESTRICTED_RECORD_ID = 'berkeley-s7b12n'.freeze

  def view_record(id)
    visit "catalog/#{id}"
  end

  # def view_public_record
  #   visit "catalog/#{PUBLIC_RECORD_ID}"
  # end

  # def view_restricted_record
  #   visit "/catalog/#{RESTRICTED_RECORD_ID}"
  # end

  def click_download_button
    find('#downloads-button').click
  end

  def rm_files(file_paths)
    file_paths.compact.each { |f| FileUtils.rm_f(f) }
    Capybara.reset_sessions!
  end

  def wait_for_download(zip_file_path, timeout: 5)
    start_time = Time.current

    loop do
      elapsed_time = Time.current - start_time
      raise "Error: Timeout waiting for downloading #{zip_file_path}" if elapsed_time > timeout
      return true if File.exist?(zip_file_path)

      sleep 1
    end
  rescue StandardError => e
    Rails.logger.error e.message
    false
  end

  def verify_download(zip_file_path)
    if wait_for_download(zip_file_path)
      expect(File.exist?(zip_file_path)).to be_truthy, "Error: Downloaded data.zip file not found: #{zip_file_path}"
      verify_zip_contents(zip_file_path)
    else
      verify_incomplete_download(zip_file_path)
    end
  end

  def verify_zip_contents(zip_file_path)
    Zip::File.open(zip_file_path) do |zip_file|
      file_names = zip_file.map(&:name)
      expect(file_names).to include('SanBenito_Intersections_2016.shp'), 'Error: SanBenito_Intersections_2016.shp not found in data.zip'
    end
  end

  def verify_incomplete_download(zip_file_path)
    zip_crdownload_file = "#{zip_file_path}.crdownload"
    expect(File.exist?(zip_crdownload_file)).to be_truthy, "Error: Download not completed, and incomplete data.zip.crdownload file not found: #{zip_crdownload_file}"
    expect(File.size(zip_crdownload_file)).to be > 130_000, 'Error: Incomplete data.zip.crdownload file size <= 130,000 bytes'
  end

  def decoded_url(url)
    uri = URI.parse(url)
    decoded_query = URI.decode_www_form_component(uri.query)
    URI.decode_www_form_component("#{uri.path}?#{decoded_query}")
  end
end
