require 'rails_helper'

RSpec.describe 'View Restricted Data', js: true do
  let(:cas_url) { "/cas/login?service=#{Capybara.app_host}/users/auth/calnet/callback?url=#{Capybara.app_host}/catalog/#{CommonHelpers::RESTRICTED_RECORD_ID}" }
  before do
    view_record(CommonHelpers::RESTRICTED_RECORD_ID)
  end

  it 'display login to view and download link' do
    expect(page).to have_link('Login to View and Download')
  end

  it 'open calnet login page when clicking login to view and download link' do
    click_link('Login to View and Download')
    expect(page).to have_current_path('/cas/login', ignore_query: true)
    expect(decoded_url(page.current_url)).to eq(cas_url)
  end
end
