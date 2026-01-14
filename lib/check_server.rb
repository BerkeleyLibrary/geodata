class CheckServer
  GEOSERVER_NAME = 'geoserver'.freeze
  SECURE_GEOSERVER_NAME = 'secure_geoserver'.freeze
  SPATIAL_SERVER_NAME = 'spatial_server'.freeze

  class << self
    def geoserver(type)
      check_type(type)
      server_name = type == 'public' ? GEOSERVER_NAME : SECURE_GEOSERVER_NAME
      url = host_url(server_name)
      geoserver_url = url && "#{url.chomp('/')}/wms?service=WMS&request=GetCapabilities"
      OkComputer::Registry.register clr_msg(server_name), GeoDataHealthCheck::HttpHeadCheck.new(geoserver_url)
    end

    def spatial_server(type)
      check_type(type)
      msg = "#{type} #{SPATIAL_SERVER_NAME}"
      url = host_url(SPATIAL_SERVER_NAME)
      spatial_url = url && "#{url.chomp('/')}/#{type}/berkeley-status/data.zip"
      OkComputer::Registry.register clr_msg(msg), GeoDataHealthCheck::HttpHeadCheck.new(spatial_url)
    end

    def host_url(server_name)
      Rails.configuration.x.servers[server_name.to_sym]
    end

    def clr_msg(msg)
      msg.downcase.strip.gsub(/\s+/, '_')
    end

    def check_type(type)
      raise StandardError, "Incorrect server type #{type}, expect either 'public' or 'UCB'" unless %w[public UCB].include? type
    end
  end
end
