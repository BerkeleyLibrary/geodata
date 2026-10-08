require 'sitemap_generator'
require 'rsolr'

# Use this to set a consistent/fallback `lastmod` for catalog entries
# For more information on lastmod, see: https://www.sitemaps.org/protocol.html
# Can be a bare date (as here) or a full datetime (as is usually indexed).
# Datetime format is: https://www.w3.org/TR/NOTE-datetime
LAST_INDEXED_DATE = ENV['GEODATA_LAST_INDEXED_DATE'] || '2026-09-01'

solr = RSolr.connect url: Blacklight.connection_config[:url]
id_field = Settings.FIELDS.ID
modified_field = Settings.FIELDS.MODIFIED

SitemapGenerator::Sitemap.default_host = Rails.configuration.x.sitemap.base_url

options = { changefreq: 'yearly', priority: 0.5 }
SitemapGenerator::Sitemap.create do
  # Add catalog items to the sitemap. Loop w/cursor to avoid loading
  # tens of thousands into memory at once.
  cursor = '*'
  loop do
    response = solr.get('select', params: { q: '*:*', fl: "#{id_field},#{modified_field}", rows: 1_000, sort: "#{id_field} asc", cursorMark: cursor })
    response.fetch('response').fetch('docs').each do |document|
      lastmod = document[modified_field].presence || LAST_INDEXED_DATE
      add "/catalog/#{document[id_field]}", options.merge(lastmod:)
    end

    next_cursor = response.fetch('nextCursorMark')
    break if next_cursor == cursor

    cursor = next_cursor
  end
end
