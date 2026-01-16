module GeoDataHealthCheck
  class HttpHeadCheck < OkComputer::HttpCheck

    def check
      response = perform_request

      if response.is_a?(Net::HTTPOK) || response.is_a?(Net::HTTPRedirection)
        mark_message 'Http head check successful.'
      else
        mark_failure
        mark_message "Error: '#{url.request_uri}' http head check responded, but returned unexpeced HTTP status: #{response.code} #{response.class}. Expected 200 Net::HTTPOK."
      end
    rescue StandardError => e
      mark_message "Error: '#{e}'"
      mark_failure
    end

    def perform_request
      head_request
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      msg = "#{url.request_uri} did not respond within #{request_timeout} seconds: "
      raise ConnectionFailed, msg + e.message
    rescue StandardError => e
      raise ConnectionFailed, e.message
    end

    private

    def head_request
      Net::HTTP.start(
        url.host,
        url.port,
        use_ssl: url.scheme == 'https',
        verify_mode: OpenSSL::SSL::VERIFY_PEER,
        open_timeout: request_timeout,
        read_timeout: request_timeout
      ) do |http|
        http.head(url.request_uri)
      end
    end

  end
end
