# initializers/okcomputer.rb
# Health checks configuration

OkComputer.logger = Rails.logger
OkComputer.check_in_parallel = true

# Check that DB migrations have run
OkComputer::Registry.register 'database-migrations', OkComputer::ActiveRecordMigrationsCheck.new

# Check the Solr connection
# Requires the ping handler on the solr core (<core>/admin/ping).
core_baseurl = Blacklight.default_index.connection.uri.to_s.chomp('/')
OkComputer::Registry.register 'solr', OkComputer::SolrCheck.new(core_baseurl)

def check_geoserver(server_name)
  url = host_url(server_name)
  # geoserver_url = url && "#{url.chomp('/')}/wms?service=WMS&request=GetCapabilities"
  geoserver_url = 'https://geoservices.lib.berkeley.edu/geoserver/UCB/wms?service=WMS&version=1.1.0&request=GetMap&layers=UCB%3Af7b68n&bbox=-122.836485%2C37.808713%2C-122.409565%2C38.190532&width=768&height=686&srs=EPSG%3A4326&styles=&format=format=image/png'
  OkComputer::Registry.register clr_name(server_name), HttpHeadCheck.new(geoserver_url)
end

def check_spatial_server(server_name, type)
  message = "#{type} #{clr_name(server_name)}"
  url = host_url(server_name)
  spatial_url = url && "#{url.chomp('/')}/#{type}/berkeley-status/data.zip"
  OkComputer::Registry.register message, HttpHeadCheck.new(spatial_url)
end

def host_url(server_name)
  Rails.configuration.x.servers[server_name.to_sym]
end

def clr_name(server_name)
  server_name.gsub('_', ' ')
end
# geoserver_url = geoserver_capabilty_url(Rails.application.config.geoserver_url)
# OkComputer::Registry.register 'Check public geoserver', HttpHeadCheck.new(geoserver_url)
# pubilc_download_url = spatial_download_url(Rails.application.config.spatialserver_url)
# OkComputer::Registry.register 'Check public download', HttpHeadCheck.new(pubilc_download_url)
# secure_download_url = spatial_download_url(Rails.application.config.spatialserver_url, 'UCB')
# OkComputer::Registry.register 'Check public download', HttpHeadCheck.new(secure_download_url)

class HttpHeadCheck < OkComputer::Check
  ConnectionFailed = Class.new(StandardError)
  attr_accessor :url

  def initialize(url)
    self.url = url
  end

  def check
    return skip_check unless url

    response = perform_http_head_request
    if response.is_a?(Net::HTTPOK)
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

  def perform_http_head_request
    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', verify_mode: OpenSSL::SSL::VERIFY_PEER) do |http|
      http.head(uri.request_uri)
    end
  rescue StandardError => e
    raise ConnectionFailed, e
  end

  def skip_check
    mark_failure
    mark_message 'No URL configured; health check was skipped...'
  end
end

check_geoserver 'geoserver'
# check_geoserver 'secure_geoserver'
# check_spatial_server 'spatial_server', 'public'
# check_spatial_server 'spatial_server', 'UCB'
