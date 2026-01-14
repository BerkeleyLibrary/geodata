module GeoDataHealthCheck
  class HttpHeadCheck < OkComputer::Check
    attr_accessor :url, :request_timeout

    # rubocop:disable Lint/MissingSuper
    def initialize(url, request_timeout = 5)
      self.url = url
      self.request_timeout = request_timeout
    end
    # rubocop:enable Lint/MissingSuper

    def check
      return skip_check unless url

      response = HttpClient.request(
        :head,
        url,
        timeout: request_timeout
      )
      # sleep 14
      if response.is_a?(Net::HTTPOK) || response.is_a?(Net::HTTPRedirection)
        mark_message 'Check succeeded.'
      else
        mark_failure
        mark_message "Error: Http head check endpoint responded, but returned unexpeced HTTP status: #{response.code} #{response.class}. Expected 200 Net::HTTPOK."
      end
    rescue StandardError => e
      mark_message "Error: '#{e}'"
      mark_failure
    end

    private

    def skip_check
      mark_failure
      mark_message 'No URL configured; health check was skipped...'
    end
  end
end
