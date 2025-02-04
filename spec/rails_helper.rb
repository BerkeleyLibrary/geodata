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
Rails.root.glob('spec/support/**/*.rb').sort.each { |file| require file }

Capybara.register_driver(:remote_chrome) do |app|
  chrome_args = %w[
    --disable-smooth-scrolling
    --window-size=2560,1344
    --disable-site-isolation-trials
  ]

  chrome_options = Selenium::WebDriver::Chrome::Options.new(args: chrome_args).tap do |options|
    options.add_preference(:download, prompt_for_download: false, directory_upgrade: true, default_directory: '/home/seluser/Downloads')
    options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })
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
Capybara.app_host = "http://#{IPSocket.getaddress(Socket.gethostname)}:3000"
Capybara.server_host = '0.0.0.0'
Capybara.always_include_port = true
Capybara.run_server = false

RSpec.configure do |config|
  config.include CommonHelpers
  config.before(:each, type: :system) do
    driven_by :remote_chrome
  end
  config.use_transactional_fixtures = false
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
end
