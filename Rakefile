# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# ------------------------------------------------------------
# Rails

require File.expand_path('config/application', __dir__)
Rails.application.load_tasks
require 'solr_wrapper' unless Rails.env.production?

# ------------------------------------------------------------
# Setup

desc 'Set up DB'
task setup: %w[db:setup]

# ------------------------------------------------------------
# Check (setup + coverage)

desc 'Set up, check test coverage'
task check: %w[setup geoblacklight:index:seed spec]

# clear rspec/rails default :spec task
Rake::Task[:default].clear if Rake::Task.task_defined?(:default)

desc 'Set up, run tests, check code style, check test coverage, check for vulnerabilities'
task default: %i[check rubocop]
