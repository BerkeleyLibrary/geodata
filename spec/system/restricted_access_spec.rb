require 'rails_helper'

RSpec.describe 'View Restricted Data' do
  let(:app_hostname) { IPSocket.getaddress(Socket.gethostname) }
  let(:cas_url) { "/cas/login?service=http://#{app_hostname}:3000/users/auth/calnet/callback?url=http://#{app_hostname}:3000/catalog/berkeley-s7b12n" }
  before do
    view_restricted_record
  end

  it 'display login to view and download link' do
    expect(page).to have_link('Login to View and Download')
  end

  it 'open calnet login page when clicking login to view and download link' do
    find('.btn.btn-default').click
    decoded_path_and_query = decoded_url(page.current_url)
    expect(decoded_path_and_query).to eq(cas_url)
  end
end
