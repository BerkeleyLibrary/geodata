# initializers/okcomputer.rb
# Health checks configuration

require_relative '../../lib/http_head_check'
require_relative '../../lib/endpoint_url'

OkComputer.logger = Rails.logger
OkComputer.check_in_parallel = true

# Check that DB migrations have run
OkComputer::Registry.register 'database-migrations', OkComputer::ActiveRecordMigrationsCheck.new

# Check the Solr connection
# Requires the ping handler on the solr core (<core>/admin/ping).
core_baseurl = Blacklight.default_index.connection.uri.to_s.chomp('/')
OkComputer::Registry.register 'solr', OkComputer::SolrCheck.new(core_baseurl)

# Perform a Head request to check geoserver endpoint
geoserver_url = EndpointUrl.geoserver(:geoserver)
OkComputer::Registry.register 'geoserver', GeoDataHealthCheck::HttpHeadCheck.new(geoserver_url)

# Perform a Head request to check secure_geoserver endpoint
secure_geoserver_url = EndpointUrl.geoserver(:secure_geoserver)
OkComputer::Registry.register 'secure_geoserver', GeoDataHealthCheck::HttpHeadCheck.new(secure_geoserver_url)

# Perform a Head request to check spatial server endpoint
spatial_server_url = EndpointUrl.spatial_server(:spatial_server, 'public')
OkComputer::Registry.register 'public_spatial_server', GeoDataHealthCheck::HttpHeadCheck.new(spatial_server_url)

# Perform a Head request to check UCB spatial server endpoint
ucb_spatial_server_url = EndpointUrl.spatial_server(:spatial_server, 'UCB')
OkComputer::Registry.register 'ucb_spatial_server', GeoDataHealthCheck::HttpHeadCheck.new(ucb_spatial_server_url)
