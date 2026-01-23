require 'uri'
class EndpointUrl
  class << self
    def geoserver(server_name)
      url = get_url(server_name)
      url && "#{url.sub(%r{/+\z}, '')}/wms?service=WMS&request=GetCapabilities"
    end

    def spatial_server(server_name)
      url = Rails.configuration.x.servers[server_name]
      url && "#{url.sub(%r{/+\z}, '')}/public/berkeley-status/data.zip"
    end

    private

    def get_url(server_name)
      secret_file = Rails.configuration.x.servers[server_name]
      raise Errno::ENOENT if secret_file.nil?

      url = File.read(secret_file).chomp
      safe_url(url)
    rescue Errno::ENOENT, Errno::EACCES
      Rails.logger.error 'Failed to read GEOSERVER_URL_FILE'
      nil
    end

    def safe_url(url)
      return if url.nil?

      uri = URI(url)
      uri.user = nil
      uri.password = nil
      uri.to_s.sub(%r{/rest/?$}, '')
    end
  end
end
