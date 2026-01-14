# initializers/okcomputer.rb
# Health checks configuration
require_relative '../../lib/http_client'
require_relative '../../lib/http_head_check'
require_relative '../../lib/check_server'

OkComputer.logger = Rails.logger
OkComputer.check_in_parallel = true

# Check that DB migrations have run
OkComputer::Registry.register 'database-migrations', OkComputer::ActiveRecordMigrationsCheck.new

# Check the Solr connection
# Requires the ping handler on the solr core (<core>/admin/ping).
core_baseurl = Blacklight.default_index.connection.uri.to_s.chomp('/')
OkComputer::Registry.register 'solr', OkComputer::SolrCheck.new(core_baseurl)

# Check geoservers and spatial servers
CheckServer.geoserver 'public'
CheckServer.geoserver 'UCB'
CheckServer.spatial_server 'public'
CheckServer.spatial_server 'UCB'
