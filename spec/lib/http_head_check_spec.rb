require 'rails_helper'
require_relative '../../lib/http_head_check'

RSpec.describe GeoDataHealthCheck::HttpHeadCheck do
  let(:url) { 'https://example.com/endpoint' }
  subject(:check) { described_class.new(url) }

  describe 'initialization' do
    it 'sets the URL' do
      expect(check.url).to eq url
    end

    it 'sets default timeout to 5 seconds' do
      expect(check.request_timeout).to eq 5
    end

    it 'allows custom timeout' do
      check = described_class.new(url, 10)
      expect(check.request_timeout).to eq 10
    end
  end

  describe '#check' do
    context 'when request returns 200 OK' do
      it 'marks check as successful' do
        response = Net::HTTPOK.new('1.1', 200, 'OK')
        allow(check).to receive(:perform_request).and_return(response)

        check.check

        expect(check.message).to include('Http head check successful.')
      end
    end

    context 'when request returns 500 error' do
      it 'marks check as failed' do
        response = Net::HTTPInternalServerError.new('1.1', 500, 'Error')
        allow(check).to receive(:perform_request).and_return(response)

        check.check

        expect(check.message).to include('Error')
      end
    end

  end

  describe '#perform_request' do
    it 'Net::OpenTimeout with ConnectionFailed and formated message' do
      check_with_timeout = described_class.new(url, 7)
      allow(check_with_timeout).to receive(:head_request).and_raise(Net::OpenTimeout.new('open timeout'))

      expect { check_with_timeout.perform_request }.to raise_error(
        GeoDataHealthCheck::HttpHeadCheck::ConnectionFailed,
        a_string_including('did not respond within 7 seconds: open timeout')
      )
    end

    it 'Net::ReadTimeout with ConnectionFailed and formated message' do
      check_with_timeout = described_class.new(url, 9)
      allow(check_with_timeout).to receive(:head_request).and_raise(Net::ReadTimeout.new('read timeout'))

      expect { check_with_timeout.perform_request }.to raise_error(
        GeoDataHealthCheck::HttpHeadCheck::ConnectionFailed,
        a_string_including('did not respond within 9 seconds: Net::ReadTimeout')
      )
    end

    it 'StandardError and passes through the message' do
      err_msg = 'generic failure'
      allow(check).to receive(:head_request).and_raise(StandardError, err_msg)

      expect { check.perform_request }.to raise_error(
        GeoDataHealthCheck::HttpHeadCheck::ConnectionFailed,
        err_msg
      )
    end

    it 'wraps ArgumentError with ConnectionFailed and includes URL and error class' do
      bad_check = described_class.new(url)
      allow(bad_check).to receive(:head_request).and_raise(ArgumentError, 'invalid URI')

      expect { bad_check.perform_request }.to raise_error(
        GeoDataHealthCheck::HttpHeadCheck::ConnectionFailed,
        a_string_including("Invalid URL format for '#{url}'", 'ArgumentError', 'invalid URI')
      )
    end
  end
end
