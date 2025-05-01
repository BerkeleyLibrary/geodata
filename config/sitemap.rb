require 'sitemap_generator'
require 'rsolr'

solr = RSolr.connect url: Blacklight.connection_config[:url]

# Select all the docs from Solr
response = solr.get('select', params: { q: '*:*', fl: 'id', rows: 999_999 })

# Build a flat sorted array of all document slugs
slugs = response['response']['docs'].map { |doc| doc['id'] }.sort

# Set the host name for URL creation
default_host = {
  'production' => 'https://geodata.lib.berkeley.edu',
  'staging' => 'https://geodata.ucblib.org',
  'development' => 'http://localhost:3000'
}[Rails.env] || 'https://geodata.ucblib.org'

SitemapGenerator::Sitemap.default_host = default_host

options = { changefreq: 'yearly', priority: 0.5 }
SitemapGenerator::Sitemap.create do
  slugs.each { |slug| add "/catalog/#{slug}", options }
end
