namespace :geodata do
  namespace :index do
    desc 'Index app fixture metadata into Solr'
    task seed: :environment do
      fixtures_pattern = ENV.fetch('SOLR_FIXTURES_PATH', Rails.root.join('spec', 'fixtures', 'solr_documents', '*.json').to_s)
      docs = Dir[fixtures_pattern].flat_map { |f| JSON.parse(File.read(f)) }

      abort("No Solr fixtures found for pattern: #{fixtures_pattern}") if docs.empty?

      puts "Indexing #{docs.size} fixture document(s) from #{fixtures_pattern}"
      Blacklight.default_index.connection.add(docs)
      Blacklight.default_index.connection.commit
    end
  end
end
