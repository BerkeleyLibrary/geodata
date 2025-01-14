# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'socket'

Capybara.register_driver(:remote_chrome) do |app|
  chrome_args = %w[
    --disable-smooth-scrolling
    --headless=new
    --window-size=2560,1344
    --log-level FINE
  ]

  # chrome_prefs = {
  #   'download.prompt_for_download' => false,
  #   'download.default_directory' => '/tmp'
  # }
  #
  # chrome_args = %w[
  #   --disable-smooth-scrolling
  #   --window-size=2560,1344
  # ]
  chrome_prefs = {
    'download.prompt_for_download' => false,
    # 'download.default_directory' => '/home/seluser/Downloads',
    'download.default_directory' => '/tmp',
    'download.directory_upgrade' => true
  }

  chrome_options = Selenium::WebDriver::Chrome::Options.new(args: chrome_args, prefs: chrome_prefs).tap do |options|
    # NOTE: Different Selenium/Chrome versions set download directory differently -- see
    #       https://github.com/teamcapybara/capybara/blob/3.38.0/spec/selenium_spec_chrome.rb#L15-L20
    if (download_dir = chrome_prefs['download.default_directory'])
      options.add_preference(:download, default_directory: download_dir)
    end
  end

  capabilities = [
    chrome_options,
    Selenium::WebDriver::Remote::Capabilities.new(
      'goog:loggingPrefs' => {
        browser: 'ALL', driver: 'ALL'
      }
    )
  ]

  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 capabilities:,
                                 url: "http://#{ENV['SELENIUM_HOST'] || 'selenium.test'}:4444/")
end

Capybara.default_driver = Capybara.javascript_driver = :remote_chrome
# Capybara.app_host = 'http://app.test:3000'
# Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}" if ENV['SELENIUM_HOST'].present?
# setup for CI later
Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:3000"
Capybara.server_host = '0.0.0.0'
Capybara.always_include_port = true
Capybara.run_server = false

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :remote_chrome
  end
  config.use_transactional_fixtures = false
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
end
