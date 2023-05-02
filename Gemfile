source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem 'omniauth-cas'
gem "sprockets-rails"
gem "pg", "~> 1.4.6"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "blacklight", "~> 7.0"
gem "geoblacklight", "~> 4.0"
gem "sprockets", "< 4.0"
gem "rsolr", ">= 1.0", "< 3"
gem "bootstrap", "~> 4.0"
gem "twitter-typeahead-rails", "0.11.1.pre.corejavascript"
gem "sassc-rails", "~> 2.1"
gem "jquery-rails"
gem "devise"
gem "devise-guests", "~> 0.8"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "solr_wrapper", ">= 0.3"
end

group :development do  
  gem "web-console" 
end

group :test do
  gem "rspec-rails"
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'simplecov', '~> 0.21', require: false
  gem 'simplecov-rcov', '~> 0.2', require: false
  gem "rspec_junit_formatter", require: false
end


