require 'simplecov-rcov'

SimpleCov.start 'rails' do
  add_filter %w[/app/channels/ /app/jobs/ /bin/ /db/]
  coverage_dir 'artifacts'
  formatter SimpleCov::Formatter::RcovFormatter
  minimum_coverage 70
end

SimpleCov.at_exit do
  SimpleCov.result.format!
  puts '------ SimpleCov completed ------'
end
