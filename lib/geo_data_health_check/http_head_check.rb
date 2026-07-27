require 'net/http'
require 'openssl'
require 'uri'

require_relative 'connection_failed_error'

module GeoDataHealthCheck
  class HttpHeadCheck < OkComputer::Check
    DEFAULT_REQUEST_TIMEOUT = 5
    SUCCESS_MESSAGE = 'Http head check successful.'.freeze
    SUCCESSFUL_RESPONSE_CLASSES = [
      Net::HTTPOK,
      Net::HTTPRedirection
    ].freeze

    attr_reader :url, :request_timeout

    def initialize(url, request_timeout = DEFAULT_REQUEST_TIMEOUT)
      super()
      @url = url
      @request_timeout = request_timeout
    end

    def check
      response = perform_request

      if successful_response?(response)
        mark_message SUCCESS_MESSAGE
      else
        mark_failure
        mark_message unexpected_status_message(response)
      end
    rescue StandardError => e
      mark_message "Error: '#{e.message}'"
      mark_failure
    end

    def perform_request
      head_request
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      raise ConnectionFailedError, "#{url} did not respond within #{request_timeout} seconds: #{e.message}"
    rescue ArgumentError => e
      raise ConnectionFailedError, "Invalid URL format for '#{url}': #{e.class}: #{e.message}"
    rescue StandardError => e
      raise ConnectionFailedError, e.message
    end

    private

    def head_request
      uri = parsed_uri

      Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.is_a?(URI::HTTPS),
        verify_mode: OpenSSL::SSL::VERIFY_PEER,
        open_timeout: request_timeout,
        read_timeout: request_timeout
      ) do |http|
        http.head(uri.request_uri)
      end
    end

    def parsed_uri
      URI.parse(url).tap do |uri|
        raise ArgumentError, 'URL must include an HTTP or HTTPS scheme and host' unless http_uri?(uri)
      end
    end

    def http_uri?(uri)
      uri.is_a?(URI::HTTP) && uri.host
    end

    def successful_response?(response)
      SUCCESSFUL_RESPONSE_CLASSES.any? { |klass| response.is_a?(klass) }
    end

    def unexpected_status_message(response)
      "Error: '#{url}' http head check responded, but returned unexpected HTTP status: " \
        "#{response.code} #{response.class}. Expected 200 Net::HTTPOK or a redirect."
    end
  end
end
