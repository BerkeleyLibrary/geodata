# initializers/okcomputer.rb
# Health checks configuration
require_relative '../../lib/http_client'
require_relative '../../lib/http_head_check'
require_relative '../../lib/server_check'

OkComputer.logger = Rails.logger
OkComputer.check_in_parallel = true

# Check that DB migrations have run
OkComputer::Registry.register 'database-migrations', OkComputer::ActiveRecordMigrationsCheck.new

# Check the Solr connection
# Requires the ping handler on the solr core (<core>/admin/ping).
core_baseurl = Blacklight.default_index.connection.uri.to_s.chomp('/')
OkComputer::Registry.register 'solr', OkComputer::SolrCheck.new(core_baseurl)

SERVER_NAME_GEOSERVER = 'geoserver'.freeze
SERVER_NAME_SECUREGEOSERVER = 'secure_geoserver'.freeze
SERVER_NAME_SPATIAL = 'spatial_server'.freeze

ServerCheck.geoserver SERVER_NAME_GEOSERVER
ServerCheck.geoserver SERVER_NAME_SECUREGEOSERVER
ServerCheck.spatial_server SERVER_NAME_SPATIAL, 'public'
ServerCheck.spatial_server SERVER_NAME_SPATIAL, 'UCB'
