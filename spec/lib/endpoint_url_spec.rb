require 'rails_helper'
require_relative '../../lib/endpoint_url'

RSpec.describe EndpointUrl do
  around do |example|
    original = Rails.configuration.x.servers.dup
    Rails.configuration.x.servers.clear
    example.run
    Rails.configuration.x.servers.clear
    Rails.configuration.x.servers.merge!(original)
  end

  describe '.geoserver' do
    it 'builds a GetCapabilities URL without duplicate slashes' do
      Rails.configuration.x.servers[:geoserver] = 'https://example.com/geoserver//'

      result = described_class.geoserver(:geoserver)

      expect(result).to eq('https://example.com/geoserver/wms?service=WMS&request=GetCapabilities')
    end

    it 'returns nil when server is not configured' do
      expect(described_class.geoserver(:unknown)).to be_nil
    end
  end

  describe '.spatial_server' do
    it 'builds the status data URL trimming trailing slashes' do
      Rails.configuration.x.servers[:spatial_server] = 'https://example.com/status/'

      result = described_class.spatial_server(:spatial_server)

      expect(result).to eq('https://example.com/status/public/berkeley-status/data.zip')
    end

    it 'returns nil when server is not configured' do
      expect(described_class.spatial_server(:missing)).to be_nil
    end
  end
end
