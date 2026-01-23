module GeoDataHealthCheck
  class HttpHeadCheckNew < OkComputer::Check
    ConnectionFailed = Class.new(StandardError)
    attr_accessor :url, :request_timeout

    # rubocop:disable Lint/MissingSuper
    def initialize(url, request_timeout = 5)
      self.url = url
      self.request_timeout = request_timeout
    end
    # rubocop:enable Lint/MissingSuper

    def check
      return skip_check if url.blank?

      response = perform_request

      if response.is_a?(Net::HTTPOK) || response.is_a?(Net::HTTPRedirection)
        mark_message 'Http head check successful.'
      else
        mark_failure
        mark_message "Error: '#{url}' http head check responded, but returned unexpeced HTTP status: #{response.code} #{response.class}. Expected 200 Net::HTTPOK."
      end
    rescue StandardError => e
      mark_message "Error: '#{e}'"
      mark_failure
    end

    def perform_request
      head_request
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      msg = "#{url} did not respond within #{request_timeout} seconds: "
      raise ConnectionFailed, msg + e.message
    rescue StandardError => e
      raise ConnectionFailed, e.message
    end

    private

    def skip_check
      mark_failure
      mark_message 'No URL configured; health check was skipped...'
    end

    def head_request
      uri = URI(url)
      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == 'https',
        verify_mode: OpenSSL::SSL::VERIFY_PEER,
        open_timeout: request_timeout,
        read_timeout: request_timeout
      ) do |http|
        http.head(uri.request_uri)
      end
    end

  end
end
