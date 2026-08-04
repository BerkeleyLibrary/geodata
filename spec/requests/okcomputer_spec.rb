require 'rails_helper'

RSpec.describe 'OKComputer', type: :request do
  it 'is mounted at /okcomputer' do
    get '/okcomputer'
    expect(response).to have_http_status :ok
  end

  it 'returns all checks at /health' do
    get '/health'

    expected_keys = %w[default database database-migrations solr]

    {
      'geoserver'        => Rails.configuration.x.servers[:geoserver],
      'geoserver_secure' => Rails.configuration.x.servers[:geoserver_secure],
      'spatial_server'   => Rails.configuration.x.servers[:spatial_server]
    }.each { |name, url| expected_keys << name if url.present? }

    expect(response.parsed_body.keys).to match_array expected_keys
  end
end
