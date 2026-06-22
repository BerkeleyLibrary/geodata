source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.5'

gem 'berkeley_library-logging', '~> 0.2.7'
gem 'bootsnap', require: false
gem 'bootstrap', '~> 5.3'
gem 'cssbundling-rails'
gem 'devise'
gem 'devise-guests', '~> 0.8'
gem 'geoblacklight'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'jbuilder'
gem 'okcomputer', '~> 1.19'
gem 'omniauth'
gem 'omniauth-cas', '3.0.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0'
gem 'pg', '~> 1.4.6'
gem 'propshaft'
gem 'puma', '~> 6.4.1'
gem 'puma-plugin-delayed_stop', '~> 0.1.2'
gem 'rack-timeout', '~> 0.6.3'
gem 'rails', '~> 8.1.3'
gem 'rsolr', '>= 1.0', '< 3'
# gem 'sitemap_generator', '~> 6.3'
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
# gem 'sprockets', '< 4.0'
# gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'thruster', require: false
gem 'turbo-rails'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'tzinfo-data', platforms: %i[windows jruby]
# gem 'vite_rails', '~> 3.0'

group :development, :test do
  gem 'brakeman'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
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
