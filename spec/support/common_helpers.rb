module CommonHelpers
  EXPORT_TMP_PATH = '/opt/app/tmp/cache/downloads'.freeze
  DOWNLOAD_TMP_PATH = '/opt/app/tmp/selenium_downloads'.freeze

  def visit_public_record
    visit 'catalog/berkeley-s7038h'
  end

  def visit_restricted_record
    visit '/catalog/berkeley-s7b12n'
  end

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

  def decoded_url(url)
    uri = URI.parse(url)
    decoded_query = URI.decode_www_form_component(uri.query)
    URI.decode_www_form_component("#{uri.path}?#{decoded_query}")
  end

end
