class ServerCheck
  class << self
    def geoserver(server_name)
      url = host_url(server_name)
      geoserver_url = url && "#{url.chomp('/')}/wms?service=WMS&request=GetCapabilities"
      OkComputer::Registry.register clr_msg(server_name), GeoDataHealthCheck::HttpHeadCheck.new(geoserver_url)
    end

    def spatial_server(server_name, type)
      msg = "#{type} #{server_name}"
      url = host_url(server_name)
      spatial_url = url && "#{url.chomp('/')}/#{type}/berkeley-status/data.zip"
      OkComputer::Registry.register clr_msg(msg), GeoDataHealthCheck::HttpHeadCheck.new(spatial_url)
    end

    def host_url(server_name)
      Rails.configuration.x.servers[server_name.to_sym]
    end

    def clr_msg(msg)
      msg.downcase.strip.gsub(/\s+/, '_')
    end
  end
end
