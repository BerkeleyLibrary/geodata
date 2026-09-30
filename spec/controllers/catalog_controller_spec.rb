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

      expect(described_class.blacklight_config.basemap_provider).to eq('positron')
    end

    it 'uses the value of GEOBLACKLIGHT_BASEMAP_PROVIDER when set' do
      ENV['GEOBLACKLIGHT_BASEMAP_PROVIDER'] = 'positronLite'
      reload_catalog_controller

      expect(described_class.blacklight_config.basemap_provider).to eq('positronLite')
    end
  end

  describe 'search tracking' do
    around do |example|
      Search.transaction(requires_new: true) do
        example.run
        raise ActiveRecord::Rollback
      end
    end

    before do
      controller.params = ActionController::Parameters.new(q: 'maps')
      allow(controller).to receive(:start_new_search_session?).and_return(true)
    end

    it 'does not persist anonymous searches' do
      allow(controller).to receive(:current_user).and_return(nil)

      expect { controller.current_search_session }.not_to change(Search, :count)
      expect(controller.current_search_session).to be_nil
      expect(session[:history]).to be_nil
    end

    it 'does not persist an explicit search context for anonymous users' do
      allow(controller).to receive(:current_user).and_return(nil)
      controller.params = ActionController::Parameters.new(search_context: { q: 'maps' }.to_json)

      expect { controller.current_search_session }.not_to change(Search, :count)
      expect(controller.current_search_session).to be_nil
      expect(session[:history]).to be_nil
    end

    it 'preserves search history for signed-in users' do
      allow(controller).to receive(:current_user).and_return(User.new)

      expect { controller.current_search_session }.to change(Search, :count).by(1)
      expect(controller.current_search_session.query_params).to include('q' => 'maps')
      expect(session[:history]).to include(controller.current_search_session.id)
    end
  end
end
