require 'rails_helper'

describe EndpointUrl do
  describe '.geoserver' do
    context 'when server is configured' do
      before do
        allow(Rails.configuration.x.servers).to receive(:[]).with('test_server').and_return('https://example.com//')
      end

      it 'returns WMS endpoint URL' do
        result = EndpointUrl.geoserver('test_server')
        expect(result).to eq('https://example.com/wms?service=WMS&request=GetCapabilities')
      end

    end

    context 'when server is not configured' do
      before do
        allow(Rails.configuration.x.servers).to receive(:[]).with('missing_server').and_return(nil)
      end

      it 'returns nil' do
        result = EndpointUrl.geoserver('missing_server')
        expect(result).to be_nil
      end
    end
  end

  describe '.spatial_server' do
    context 'when server is configured' do
      before do
        allow(Rails.configuration.x.servers).to receive(:[]).with('test_server').and_return('https://example.com//')
      end

      it 'returns spatial server data zip endpoint URL' do
        result = EndpointUrl.spatial_server('test_server')
        expect(result).to eq('https://example.com/public/berkeley-status/data.zip')
      end

    end

    context 'when server is not configured' do
      before do
        allow(Rails.configuration.x.servers).to receive(:[]).with('missing_server').and_return(nil)
      end

      it 'returns nil' do
        result = EndpointUrl.spatial_server('missing_server')
        expect(result).to be_nil
      end
    end
  end
end
