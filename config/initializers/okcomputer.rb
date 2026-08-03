# initializers/okcomputer.rb
# Health checks configuration

require 'berkeley_library/util/uris/head_check'

OkComputer.logger = Rails.logger
OkComputer.check_in_parallel = ActiveModel::Type::Boolean.new.cast(ENV.fetch('OKCOMPUTER_CHECK_IN_PARALLEL', false))

OkComputer::Registry.register 'default', OkComputer::Registry.fetch('default')
OkComputer::Registry.register 'database', OkComputer::Registry.fetch('database')

# Check that DB migrations have run
OkComputer::Registry.register 'database-migrations', OkComputer::ActiveRecordMigrationsCheck.new

# Check the Solr connection
# Requires the ping handler on the solr core (<core>/admin/ping).
blacklight_config = Rails.application.config_for(:blacklight)
solr_url = blacklight_config['url'] || blacklight_config[:url]

if solr_url.present?
  core_baseurl = solr_url.to_s.chomp('/')
  OkComputer::Registry.register 'solr', OkComputer::SolrCheck.new(core_baseurl, 1)
else
  OkComputer.logger.warn('OkComputer Solr check skipped: no Solr URL configured in Blacklight')
end

{
  geoserver: Rails.configuration.x.servers[:geoserver],
  geoserver_secure: Rails.configuration.x.servers[:geoserver_secure],
  spatial_server: Rails.configuration.x.servers[:spatial_server]
}.each do |name, url|
  next if url.blank?

  OkComputer::Registry.register name.to_s, BerkeleyLibrary::Util::HeadCheck.new(url, 1)
end
