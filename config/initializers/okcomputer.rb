# initializers/okcomputer.rb
# Health checks configuration

require_relative '../../lib/geo_data_health_check'

OkComputer.logger = Rails.logger
OkComputer.check_in_parallel = true

health_check_timeout = 0.9

timed_health_check = ->(check) do
  GeoDataHealthCheck::TimedHealthCheck.new(check, timeout: health_check_timeout)
end

OkComputer::Registry.register 'default', timed_health_check.call(OkComputer::Registry.fetch('default'))
OkComputer::Registry.register 'database', timed_health_check.call(OkComputer::Registry.fetch('database'))

# Check that DB migrations have run
OkComputer::Registry.register 'database-migrations', timed_health_check.call(OkComputer::ActiveRecordMigrationsCheck.new)

# Check the Solr connection
# Requires the ping handler on the solr core (<core>/admin/ping).
core_baseurl = Blacklight.default_index.connection.uri.to_s.chomp('/')
OkComputer::Registry.register 'solr', timed_health_check.call(OkComputer::SolrCheck.new(core_baseurl, 1))

{
  geoserver: Rails.configuration.x.servers[:geoserver],
  geoserver_secure: Rails.configuration.x.servers[:geoserver_secure],
  spatial_server: Rails.configuration.x.servers[:spatial_server]
}.each do |name, url|
  next if url.blank?

  OkComputer::Registry.register name.to_s, timed_health_check.call(GeoDataHealthCheck::HttpHeadCheck.new(url, health_check_timeout))
end
