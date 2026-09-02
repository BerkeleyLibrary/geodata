require 'rails_helper'

RSpec.describe CatalogController do
  describe 'basemap provider configuration' do
    around do |example|
      original_controller = CatalogController
      original_provider = ENV.delete('GEOBLACKLIGHT_BASEMAP_PROVIDER')
      ENV['GEOBLACKLIGHT_BASEMAP_PROVIDER'] = basemap_provider if basemap_provider
      Object.send(:remove_const, :CatalogController)
      load Rails.root.join('app/controllers/catalog_controller.rb')

      example.run
    ensure
      ENV.delete('GEOBLACKLIGHT_BASEMAP_PROVIDER')
      ENV['GEOBLACKLIGHT_BASEMAP_PROVIDER'] = original_provider if original_provider
      Object.send(:remove_const, :CatalogController)
      Object.const_set(:CatalogController, original_controller)
    end

    context 'when GEOBLACKLIGHT_BASEMAP_PROVIDER is set' do
      let(:basemap_provider) { 'openstreetmapStandard' }

      it 'uses the configured provider' do
        expect(CatalogController.blacklight_config.basemap_provider).to eq('openstreetmapStandard')
      end
    end

    context 'when GEOBLACKLIGHT_BASEMAP_PROVIDER is not set' do
      let(:basemap_provider) { nil }

      it 'uses positron by default' do
        expect(CatalogController.blacklight_config.basemap_provider).to eq('positron')
      end
    end
  end
end
