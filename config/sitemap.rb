require 'sitemap_generator'
require 'rsolr'

solr = RSolr.connect url: Blacklight.connection_config[:url]

# Select all the docs from Solr
response = solr.get('select', params: { q: '*:*', fl: 'id', rows: 999_999 })

# Build a flat sorted array of all document slugs
slugs = response['response']['docs'].pluck('id').sort

SitemapGenerator::Sitemap.default_host = Rails.configuration.x.sitemap.base_url

options = { changefreq: 'yearly', priority: 0.5 }
SitemapGenerator::Sitemap.create do
  slugs.each { |slug| add "/catalog/#{slug}", options }
end
