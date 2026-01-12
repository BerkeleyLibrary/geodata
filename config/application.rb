# Read Docker secrets into the environment
Dir['/run/secrets/*'].each do |filepath|
  secret = File.read(filepath)
  secret_name = File.basename(filepath)
  ENV[secret_name] ||= secret unless secret.empty?
end

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Geodata
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.action_mailer.default_options = { from: 'fake@berkeley.edu' }
    config.lit_gtag_id = ENV.fetch('LIT_GTAG_ID', nil)

    config.geoserver_url = ENV.fetch('GEOSERVER_URL', 'https://geoserver-public.ucblib.org/geoserver')
    config.spatialserver_url = ENV.fetch('SPATIAL_URL', 'https://spatial.ucblib.org')

    config.x.servers ||= {}

    # config.x.servers[:geoserver] = ENV.fetch('GEOSERVER_URL', nil)
    # config.x.servers[:secure_geoserver] = ENV.fetch('GEOSERVER_URL', nil)
    # config.x.servers[:spatial_server] = ENV.fetch('SPATIAL_URL', nil)

    # The Base URL for the generated sitemap
    config.x.sitemap.base_url = ENV.fetch('GEODATA_BASE_URL', 'http://localhost:3000')
    # Silenced by default to minimize log noise
    # @see https://ucblib.atlassian.net/browse/DEV-517
    Deprecation.default_deprecation_behavior = ENV.fetch('LIT_DEPRECATION_BEHAVIOR', 'silence').to_sym

    config.i18n.load_path += Rails.root.glob('config/locales/**/*.{rb,yml}')
    config.i18n.default_locale = :en

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
