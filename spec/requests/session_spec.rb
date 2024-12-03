require 'rails_helper'

# Get a test user, then testing Devise

RSpec.describe 'Sessions' do
  # not use this action anymore
  # it 'can redirect Calnet login form' do
  #   get new_user_session_path
  #   expect(response).to have_http_status(302)
  # end

  it 'can redirect Calnet logout form' do
    get destroy_user_session_path
    expect(response).to have_http_status(302)
  end

  # not use redirection anymore
  # it 'redirects to auth.berkeley.edu' do
  #   get user_calnet_omniauth_authorize_path
  #   expect(response).to have_http_status(302)
  #   expect(response.location).to match(%r{https://auth-test.berkeley.edu})
  # end
end
