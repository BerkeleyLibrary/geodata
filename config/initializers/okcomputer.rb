# initializers/okcomputer.rb
# Health checks configuration

require_relative '../../lib/http_head_check'

OkComputer.logger = Rails.logger
OkComputer.check_in_parallel = true

# Check that DB migrations have run
OkComputer::Registry.register 'database-migrations', OkComputer::ActiveRecordMigrationsCheck.new

# Check the Solr connection
# Requires the ping handler on the solr core (<core>/admin/ping).
core_baseurl = Blacklight.default_index.connection.uri.to_s.chomp('/')
OkComputer::Registry.register 'solr', OkComputer::SolrCheck.new(core_baseurl)

# Perform a Head request to check geoserver endpoint
geoserver_url = Rails.configuration.x.servers[:geoserver]
OkComputer::Registry.register 'geoserver', GeoDataHealthCheck::HttpHeadCheck.new(geoserver_url)

# Perform a Head request to check secure_geoserver endpoint
geoserver_secure_url = Rails.configuration.x.servers[:geoserver_secure]
OkComputer::Registry.register 'geoserver_secure', GeoDataHealthCheck::HttpHeadCheck.new(geoserver_secure_url)

# Perform a Head request to check spatial server endpoint
spatial_server_url = Rails.configuration.x.servers[:spatial_server]
OkComputer::Registry.register 'spatial_server', GeoDataHealthCheck::HttpHeadCheck.new(spatial_server_url)
