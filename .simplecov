require 'simplecov-rcov'

SimpleCov.start 'rails' do
  add_filter %w[/app/channels/ /app/jobs/ /bin/ /db/]
  coverage_dir 'artifacts'
  formatter SimpleCov::Formatter::RcovFormatter
  minimum_coverage 60
end
