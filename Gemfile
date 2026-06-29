source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.9'

gem 'berkeley_library-logging', '~> 0.3.0'
gem 'bootsnap', require: false
gem 'bootstrap', '~> 5.3'
gem 'cssbundling-rails'
gem 'devise'
gem 'devise-guests', '~> 0.8'
gem 'geoblacklight', '~> 5.3.0'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'jbuilder'
gem 'okcomputer', '~> 1.19'
gem 'omniauth'
gem 'omniauth-cas', '~> 3.0.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0'
gem 'pg', '~> 1.6'
gem 'propshaft'
gem 'puma', '~> 7.0'
gem 'puma-plugin-delayed_stop', '~> 0.1.2'
gem 'rack-timeout', '~> 0.6.3'
gem 'rails', '~> 8.1.3'
gem 'rsolr', '>= 1.0', '< 3'
gem 'sitemap_generator', '~> 6.3'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', '~> 2.35.0', require: false
  gem 'rubocop-rspec', '~> 2.31.0', require: false
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
