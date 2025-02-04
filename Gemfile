source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'berkeley_library-logging', '~> 0.2.7'
gem 'blacklight', '~> 7.0'
gem 'bootsnap', require: false
gem 'bootstrap', '~> 4.0'
gem 'devise'
gem 'devise-guests', '~> 0.8'
gem 'geoblacklight', '~> 4.4.2'
gem 'importmap-rails'
gem 'jbuilder'
gem 'jquery-rails'
gem 'omniauth'
gem 'omniauth-cas', '3.0.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0'
gem 'pg', '~> 1.4.6'
gem 'puma', '~> 6.4.1'
gem 'rack-timeout', '~> 0.6.3'
gem 'rails', '~> 7.1.5'
gem 'rsolr', '>= 1.0', '< 3'
gem 'sassc-rails', '~> 2.1'
gem 'sprockets', '< 4.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'vite_rails', '~> 3.0'

group :development, :test do
  gem 'brakeman'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', '~> 2.19', '>= 2.19.1', require: false
  gem 'rubocop-rspec', '~> 2.20', require: false
  gem 'solr_wrapper', '>= 0.3'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'rspec', '~> 3.13'
  gem 'rspec_junit_formatter', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.21', require: false
  gem 'simplecov-rcov', '~> 0.2', require: false
end
