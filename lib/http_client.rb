require 'net/http'
require 'uri'
require 'openssl'

module GeoDataHealthCheck
  class HttpClient
    ConnectionFailed = Class.new(StandardError)

    class << self
      def request(method, url, timeout: 5)
        uri = URI(url)

        Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: uri.scheme == 'https',
          verify_mode: OpenSSL::SSL::VERIFY_PEER,
          open_timeout: timeout,
          read_timeout: timeout # or just skip checking reading timeout?
        ) do |http|
          req = build_request(method, uri)
          http.request(req)
        end
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        msg = "Http #{method} #{url} did not respond within #{request_timeout} seconds: "
        raise ConnectionFailed, msg + e.message
      rescue StandardError => e
        raise ConnectionFailed, e.message
      end

      def build_request(method, uri)
        req_method = method.downcase.to_sym
        raise ConnectionFailed, "Incorrect http request method: #{method}" unless %i[head get].include?(req_method)

        req_klass = method == :head ? Net::HTTP::Head : Net::HTTP::Get
        req_klass.new(uri)
      end
    end

  end
end
