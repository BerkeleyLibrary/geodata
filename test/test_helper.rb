require 'capybara/rails'
require 'selenium-webdriver'

Capybara.register_driver :remote_chrome do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: "http://#{ENV['SELENIUM_HOST'] || 'selenium.test'}:4444/",
    capabilities: :chrome
  )
end

Capybara.javascript_driver = :remote_chrome
Capybara.server_host = '0.0.0.0'
Capybara.server_port = 3001 # Use a different port for the Rails test server
Capybara.app_host = 'http://app.test:3001'
