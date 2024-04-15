# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
# require 'factory_bot'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

Capybara.register_driver :remote_selenium_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--no-sandbox')
  # options.add_argument('--disable-dev-shm-usage')
#   options.add_argument('--disable-gpu')
  options.add_argument('--window-size=2560,1344')
  options.add_argument('--disable-smooth-scrolling')
  capabilities = [
    options,
    Selenium::WebDriver::Remote::Capabilities.new(
      'goog:loggingPrefs' => {
        browser: 'ALL', driver: 'ALL'
      }
    )
  ]

  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    capabilities:,
    url: "http://#{ENV['SELENIUM_HOST'] || 'selenium'}:4444/",
  )

end

Capybara.default_driver = Capybara.javascript_driver = :remote_selenium_headless

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
