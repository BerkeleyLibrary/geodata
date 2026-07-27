# initializers/okcomputer.rb
# Health checks configuration

require_relative '../../lib/geo_data_health_check/http_head_check'

if ENV['SKIP_OKCOMPUTER_INIT'] == '1'
  Rails.logger.info('Skipping OkComputer initializer during build-time tasks')
else
  OkComputer.logger = Rails.logger
  OkComputer.check_in_parallel = ActiveModel::Type::Boolean.new.cast(ENV.fetch('OKCOMPUTER_CHECK_IN_PARALLEL', false))

  OkComputer::Registry.register 'default', OkComputer::Registry.fetch('default')
  OkComputer::Registry.register 'database', OkComputer::Registry.fetch('database')

  # Check that DB migrations have run
  OkComputer::Registry.register 'database-migrations', OkComputer::ActiveRecordMigrationsCheck.new

  # Check the Solr connection
  # Requires the ping handler on the solr core (<core>/admin/ping).
  core_baseurl = Blacklight.default_index.connection.uri.to_s.chomp('/')
  OkComputer::Registry.register 'solr', OkComputer::SolrCheck.new(core_baseurl, 1)

  {
    geoserver: Rails.configuration.x.servers[:geoserver],
    geoserver_secure: Rails.configuration.x.servers[:geoserver_secure],
    spatial_server: Rails.configuration.x.servers[:spatial_server]
  }.each do |name, url|
    next if url.blank?

    OkComputer::Registry.register name.to_s, GeoDataHealthCheck::HttpHeadCheck.new(url, 0.9)
  end
end
