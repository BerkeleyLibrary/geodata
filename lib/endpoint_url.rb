class EndpointUrl
  class << self
    def geoserver(server_name)
      url = Rails.configuration.x.servers[server_name]
      url && "#{url.sub(%r{/+\z}, '')}/wms?service=WMS&request=GetCapabilities"
    end

    def spatial_server(server_name)
      url = Rails.configuration.x.servers[server_name]
      url && "#{url.sub(%r{/+\z}, '')}/public/berkeley-status/data.zip"
    end
  end
end
