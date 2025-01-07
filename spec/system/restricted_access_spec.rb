require 'rails_helper'

RSpec.describe 'View Restricted Data' do
  let(:app_hostname) { IPSocket.getaddress(Socket.gethostname) }
  let(:cas_url) { "/cas/login?service=http://#{app_hostname}:3000/users/auth/calnet/callback?url=http://#{app_hostname}:3000/catalog/berkeley-s7b12n" }
  before do
    visit '/catalog/berkeley-s7b12n'
  end

  it 'display login to view and download link' do
    expect(page).to have_link('Login to View and Download')
  end

  it 'open calnet login page when clicking login to view and download link' do
    find('.btn.btn-default').click
    raw_url = page.current_url
    uri = URI.parse(raw_url)
    decoded_query = URI.decode_www_form_component(uri.query)
    decoded_path_and_query = URI.decode_www_form_component("#{uri.path}?#{decoded_query}")
    expect(decoded_path_and_query).to eq(cas_url)
  end
end
