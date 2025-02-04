require 'rails_helper'

# Do not get new_user_session_path and user_calnet_omniauth_authorize_path anymore
# Use a system test in 'restricted_access_spec.rb'

RSpec.describe 'Calnet logout' do

  it 'can redirect Calnet logout form' do
    get destroy_user_session_path
    expect(response).to have_http_status(302)
  end

end
