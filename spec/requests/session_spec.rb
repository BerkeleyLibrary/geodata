require 'rails_helper'

# Get a test user, then testing Devise

RSpec.describe 'Sessions' do
  it 'can redirect Calnet login form' do
    get new_user_session_path
    expect(response).to have_http_status(302)
  end

  it 'can redirect Calnet logout form' do
    get destroy_user_session_path
    expect(response).to have_http_status(302)
  end
end
