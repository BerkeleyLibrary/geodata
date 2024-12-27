require 'rails_helper'

# RSpec.describe 'View Restricted Data', type: :system do
RSpec.describe 'View Restricted Data' do
  before do
    visit '/catalog/berkeley-s7b12n'
  end

  it 'display login to view and download link' do
    expect(page).to have_link('Login to View and Download')
  end

  it 'clicking login to view and download link' do
    find('.btn.btn-default').click
    login_url = '/cas/login?service=http://app.test:3000/users/auth/calnet/callback?url=http%3A%2F%2Fapp.test%3A3000%2Fcatalog%2Fberkeley-s7b12n'
    raw_url = page.current_url
    uri = URI.parse(raw_url)
    decoded_path_and_query = URI.decode_www_form_component("#{uri.path}?#{uri.query}")
    expect(decoded_path_and_query).to eq(login_url)
  end
end
