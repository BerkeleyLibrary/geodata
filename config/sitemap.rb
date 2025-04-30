require 'sitemap_generator'
require 'rsolr'

solr = RSolr.connect url: Blacklight.connection_config[:url]

# Select all the docs from Solr
response = solr.get('select', params: { q: '*:*', fl: 'id', rows: 999_999 })

# Build a flat sorted array of all document slugs
slugs = response['response']['docs'].map { |doc| doc['id'] }.sort

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Rails.env.production? ? 'https://geodata.lib.berkeley.edu' : 'http://localhost:3000'

options = { changefreq: 'yearly', priority: 0.5 }
SitemapGenerator::Sitemap.create do
  slugs.each { |slug| add "/catalog/#{slug}", options }
end
