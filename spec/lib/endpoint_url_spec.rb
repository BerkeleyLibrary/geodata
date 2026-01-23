require 'rails_helper'

describe EndpointUrl do
  describe '.geoserver' do
    context 'when server is configured and file exists' do
      let(:secret_file) { 'tmp/test_secret.txt' }

      before do
        allow(Rails.configuration.x.servers).to receive(:[]).with('test_server').and_return(secret_file)
        File.write(secret_file, 'https://user:pass@example.com/rest/')
      end

      after do
        FileUtils.rm_f(secret_file)
      end

      it 'returns WMS endpoint URL' do
        result = EndpointUrl.geoserver('test_server')
        expect(result).to eq('https://example.com/wms?service=WMS&request=GetCapabilities')
      end
    end

    context 'when file does not exist' do
      before do
        allow(Rails.configuration.x.servers).to receive(:[]).with('test_server').and_return('nonexistent_file.txt')
      end

      it 'logs error and returns nil' do
        expect(Rails.logger).to receive(:error).with(/Failed to read GEOSERVER_URL_FILE/)
        result = EndpointUrl.geoserver('test_server')
        expect(result).to be_nil
      end
    end

    context 'when server is not configured' do
      before do
        allow(Rails.configuration.x.servers).to receive(:[]).with('missing_server').and_return(nil)
      end

      it 'returns nil without logging error' do
        result = EndpointUrl.geoserver('missing_server')
        expect(result).to be_nil
      end
    end
  end

  describe '.spatial_server' do
    context 'when server is configured' do
      before do
        allow(Rails.configuration.x.servers).to receive(:[]).with('test_server').and_return('https://example.com')
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
