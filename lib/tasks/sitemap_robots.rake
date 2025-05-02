namespace :sitemap do
  desc 'Generate robots.txt including sitemap link'
  task robots: :environment do
    require 'erb'

    @base_url = Rails.configuration.x.sitemap.base_url
    template_path = Rails.root.join('lib', 'templates', 'robots.txt.erb')
    template = ERB.new(File.read(template_path))
    content = template.result(binding)

    # Write the file
    output_path = Rails.public_path.join('robots.txt')
    File.write(output_path, content)

    Rails.logger.info("robots.txt successfully generated at #{output_path}")
  end
end
