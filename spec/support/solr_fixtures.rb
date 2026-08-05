RSpec.configure do |config|
  config.before(:suite) do
    fixtures_path = Rails.root.join('spec', 'fixtures', 'solr_documents', '*.json')
    docs = Dir[fixtures_path].flat_map { |f| JSON.parse(File.read(f)) }
    Blacklight.default_index.connection.add(docs)
    Blacklight.default_index.connection.commit
  end
end
