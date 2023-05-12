# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# ------------------------------------------------------------
# Rails

require File.expand_path('config/application', __dir__)
Rails.application.load_tasks
# require 'solr_wrapper/rake_task' unless Rails.env.production?

# ------------------------------------------------------------
# Setup

desc 'Set up DB'
task setup: %w[db:await db:setup]

# ------------------------------------------------------------
# Check (setup + coverage)

desc 'Set up, check test coverage'
task :check do
  raise "Can't run specs; expected RAILS_ENV=\"test\", was #{Rails.env.inspect}" unless Rails.env.test?

  Rake::Task[:setup].invoke
  # Rake::Task[:coverage].invoke
  Rake::Task[:solr:restart].invoke  
  # may not need to call this
  # Rake::Task[:geoblacklight:index:seed].invoke
  Rake::Task[:rspec].invoke
end

# clear rspec/rails default :spec task
Rake::Task[:default].clear if Rake::Task.task_defined?(:default)

desc 'Set up, run tests, check code style, check test coverage, check for vulnerabilities'
task default: %i[check rubocop]
