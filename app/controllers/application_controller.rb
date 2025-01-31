class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout :determine_layout if respond_to? :layout

  before_action :allow_geoblacklight_params

  def allow_geoblacklight_params
    # Blacklight::Parameters will pass these to params.permit
    blacklight_config.search_state_fields.append(Settings.GBL_PARAMS)
  end

  # root will be used as new_session_path
  # Shim because we're not using Devise's :database_authenticatable

  # @param [String] return_url address that calnet will redirect to post-logout
  # @return [String] uri to the calnet sso page
  def calnet_logout_url(return_url = root_url)
    host = Devise.omniauth_configs[:calnet].options[:host]
    path = Devise.omniauth_configs[:calnet].options[:logout_url]
    URI::HTTPS.build(host:, path:, query: {
      service: return_url
    }.to_query).to_s
  end

end
