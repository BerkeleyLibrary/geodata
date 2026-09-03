require 'rails_helper'

RSpec.describe CatalogController do
  def reload_catalog_controller
    # Force blacklight_config to be rebuilt from scratch to avoid raising repeated calls
    # like config.view.split(...).
    described_class.instance_variable_set(:@blacklight_config, nil)
    load Rails.root.join('app/controllers/catalog_controller.rb')
  end

  around do |example|
    original_value = ENV.fetch('GEOBLACKLIGHT_BASEMAP_PROVIDER', nil)
    example.run
  ensure
    ENV['GEOBLACKLIGHT_BASEMAP_PROVIDER'] = original_value
    reload_catalog_controller
  end

  describe 'basemap_provider configuration' do
    it 'defaults to openstreetmapStandard when GEOBLACKLIGHT_BASEMAP_PROVIDER is not set' do
      ENV.delete('GEOBLACKLIGHT_BASEMAP_PROVIDER')
      reload_catalog_controller

      expect(described_class.blacklight_config.basemap_provider).to eq('openstreetmapStandard')
    end

    it 'uses the value of GEOBLACKLIGHT_BASEMAP_PROVIDER when set' do
      ENV['GEOBLACKLIGHT_BASEMAP_PROVIDER'] = 'positronLite'
      reload_catalog_controller

      expect(described_class.blacklight_config.basemap_provider).to eq('positronLite')
    end
  end
end
