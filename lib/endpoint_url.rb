class EndpointUrl
  class << self
    def geoserver(server_name)
      url = get_url(server_name)
      url && "#{url.sub(%r{/+\z}, '')}/wms?service=WMS&request=GetCapabilities"
    end

    def spatial_server(server_name)
      url = get_url(server_name)
      url && "#{url.sub(%r{/+\z}, '')}/public/berkeley-status/data.zip"
    end

    private

    def get_url(server_name)
      Rails.configuration.x.servers[server_name]
    end
  end
end
