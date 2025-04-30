namespace :sitemap do
  desc 'Generate robots.txt including sitemap link'
  task generator: :environment do
    # Use a dynamic sitemap URL based on environment: propduction or localhost (need staging?)

    default_host = {
      'production' => 'https://geodata.lib.berkeley.edu',
      'staging' => 'https://geodata.ucblib.org',
      'development' => 'http://localhost:3000'
    }[Rails.env] || 'https://geodata.ucblib.org'

    sitemap_url = "#{default_host}/sitemap.xml.gz"

    # Robots.txt content
    robots_content = <<~ROBOTS
      # See http://www.robotstxt.org/robotstxt.html for documentation on how to use the robots.txt file
      User-agent: SiteimproveBot-Crawler
      Allow: /

      User-agent: *
      Disallow: /?q=
      Disallow: /*?q=*
      Disallow: /?f
      Disallow: /*?f*
      Disallow: /?_
      Disallow: /?bbox
      Disallow: /?page=
      Disallow: /bookmarks
      Disallow: /catalog.html?f
      Disallow: /catalog.html?_
      Disallow: /catalog.atom
      Disallow: /catalog.rss
      Disallow: /catalog/*/relations
      Disallow: /catalog/facet/*
      Disallow: /catalog/*/web_services
      Disallow: /catalog/email
      Disallow: /catalog/opensearch
      Disallow: /catalog/range_limit
      Disallow: /catalog/sms
      Disallow: /saved_searches
      Disallow: /search_history
      Disallow: /suggest
      Disallow: /users
      Disallow: /404
      Disallow: /422
      Disallow: /500

      User-agent: AhrefsBot
      Disallow: /

      User-agent: SemrushBot
      Disallow: /

      User-agent: PetalBot
      Disallow: /

      User-agent: BLEXBot
      Disallow: /

      User-agent: DotBot
      Disallow: /

      User-agent: DataForSeoBot
      Disallow: /

      Sitemap: #{sitemap_url}
    ROBOTS

    # Write the file
    path = Rails.public_path.join('robots.txt')
    File.write(path, robots_content)

    Rails.logger.info("robots.txt successfully generated at #{path}")
  end
end
