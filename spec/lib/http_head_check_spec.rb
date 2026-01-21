require 'spec_helper'
require_relative '../../lib/http_head_check'

RSpec.describe GeoDataHealthCheck::HttpHeadCheck do
  let(:test_url) { URI('http://example.com/endpoint') }
  let(:check) { described_class.new(test_url) }

  describe '#check' do
    it 'succeeds when response is 200 OK' do
      response = Net::HTTPOK.new('1.1', '200', 'OK')
      allow(check).to receive(:perform_request).and_return(response)

      check.check

      expect(check.message).to include('Http head check successful.')
    end

    it 'succeeds when response is a redirect' do
      response = Net::HTTPFound.new('1.1', '302', 'Found')
      allow(check).to receive(:perform_request).and_return(response)

      check.check

      expect(check.message).to include('Http head check successful.')
    end

    it 'fails when response is 404' do
      response = Net::HTTPNotFound.new('1.1', '404', 'Not Found')
      allow(check).to receive(:perform_request).and_return(response)

      check.check

      expect(check.message).to include('http head check responded, but returned unexpeced HTTP status: 404 Net::HTTPNotFound')
    end

    it 'fails when request raises an error' do
      error = StandardError.new('Connection error')
      allow(check).to receive(:perform_request).and_raise(error)

      check.check

      expect(check.message).to include('Error:')
      expect(check.message).to include('Connection error')
    end
  end

  describe '#perform_request' do
    it 'calls head_request' do
      response = Net::HTTPOK.new('1.1', '200', 'OK')
      allow(check).to receive(:head_request).and_return(response)

      result = check.perform_request

      expect(result).to eq response
    end

    it 'raises ConnectionFailed on OpenTimeout' do
      allow(check).to receive(:head_request).and_raise(Net::OpenTimeout.new)

      expect do
        check.perform_request
      end.to raise_error(OkComputer::HttpCheck::ConnectionFailed)
    end

    it 'raises ConnectionFailed on ReadTimeout' do
      allow(check).to receive(:head_request).and_raise(Net::ReadTimeout.new)

      expect do
        check.perform_request
      end.to raise_error(OkComputer::HttpCheck::ConnectionFailed)
    end

    it 'raises ConnectionFailed on StandardError' do
      allow(check).to receive(:head_request).and_raise(StandardError.new)

      expect do
        check.perform_request
      end.to raise_error(OkComputer::HttpCheck::ConnectionFailed)
    end
  end
end
