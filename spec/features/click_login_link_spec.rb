# require 'spec_helper'
require 'rails_helper'

# RSpec.feature 'Clicking login link on root page', type: :feature do
#   scenario 'User clicks login link and is redirected login page' do
#     Rails.logger.info 'User is logged in'
#     visit root_path
#     click_link 'login'
#     logger.info("PPPPP-#{user_calnet_omniauth_authorize_path}")
#     expect(page).to have_current_path(user_calnet_omniauth_authorize_path)
#   end
# end


# describe 'User Util Links' do
#     it 'has link' do
#        visit root_path
#        click_link 'login'
#     #    logger.info("PPPPP-#{user_calnet_omniauth_authorize_path}")
#     #    expect(page).to have_current_path(user_calnet_omniauth_authorize_path)
#     end
# end

RSpec.feature 'Homepage', type: :feature, js: true do
  include Capybara::DSL
  scenario 'User visits the homepage' do
    # root_path = 'https://www.google.com'
    # sleep(60)
    root_path = 'http://app.test:3000/'
    visit root_path
    expect(page).to have_content('UC Berkeley GeoData Repository')
  end
end