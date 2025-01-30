# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
# require 'factory_bot'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

################## from TIND_QA ######################

# require 'rspec'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver(:remote) do |app|
  chrome_args = %w[
    --disable-smooth-scrolling
    --headless
    --window-size=2560,1344
  ]

  chrome_prefs = {
    'download.prompt_for_download' => false,
    'download.default_directory' => '/tmp'
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

Capybara.default_driver = Capybara.javascript_driver = :remote
Capybara.app_host = 'http://app.test:3000'
Capybara.server_host = '0.0.0.0'
Capybara.always_include_port = true

#############

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
