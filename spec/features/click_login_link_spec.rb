require 'rails_helper'
require 'uri'

RSpec.feature 'Open home page', type: :feature do
  scenario 'Open home page to view institutions' do
    visit root_path
    expect(page).to have_title('UC Berkeley GeoData Repository')
  end
end

# RSpec.feature 'Clicking login link on home page', type: :feature do
#   scenario 'User clicks login link and goes redirected login page' do
#     visit root_path
#     click_on('Login')
#     url = '/cas/login?service=http%3A%2F%2Fapp.test%3A3000%2Fusers%2Fauth%2Fcalnet%2Fcallback%3Furl%3Dhttp%253A%252F%252Fapp.test%253A3000%252F'
#     expect(page).to have_current_path(url)
#     visit url
#     expect(page).to have_title('CAS - CalNet Authentication Service Login')
#     # within('loginForm') do
#     fill_in 'username', with: 'test'
#     fill_in 'password', with: 'test'
#     # end
#     click_on('submit')
#     expect(page).to have_title('UC Berkeley GeoData Repository')
#   end
# end

# RSpec.feature 'Homepage', type: :feature, js: true do
#   include Capybara::DSL
#   scenario 'User visits the homepage' do
#     # # root_path = 'https://www.google.com'
#     # # sleep(60)
#     # root_path = 'http://app.test:3000/'
#     visit root_path
#     expect(page).to have_title('UC Berkeley GeoData Repository')
#   end
# end

!RSpec.feature 'Homepage', type: :feature, js: true do
  include Capybara::DSL
  scenario 'User clicks login link and goes redirected login page' do
    # visit root_path
    # click_on('Login')
    # url = 'https://auth-test.berkeley.edu/cas/login?service=http%3A%2F%2Fapp.test%3A3000%2Fusers%2Fauth%2Fcalnet%2Fcallback%3Furl%3Dhttp%253A%252F%252Fapp.test%253A3000%252F'
    # # calnet_path = "#{root_path}#{url}"
    url = 'https://auth-test.berkeley.edu/cas/login?service=http://localhost:3000/users/auth/calnet/callback?url=http://localhost:3000/'
    # url = 'https://auth-test.berkeley.edu/cas/login?service=http://app.test:3000/users/auth/calnet/callback?url=http://app.test:3000/'
    visit url

    expect(page).to have_title('CAS - CalNet Authentication Service Login')
    # within('loginForm') do
    # fill_in 'username', with: 'test'
    # fill_in 'password', with: 'test'
    # # end
    # click_on('submit')
    # expect(page).to have_title('UC Berkeley GeoData Repository')
  end
end

# RSpec.feature 'Clicking login link on home page', type: :feature do
#   scenario 'User clicks login link and goes redirected login page' do
#     visit root_path
#     click_on('Login')
#     url = '/cas/login?service=http%3A%2F%2Fapp.test%3A3000%2Fusers%2Fauth%2Fcalnet%2Fcallback%3Furl%3Dhttp%253A%252F%252Fapp.test%253A3000%252F'
#     expect(page).to have_current_path(url)
#     # visit url
#     expect(page).to have_title('CAS - CalNet Authentication Service Login')
#     # within('loginForm') do
#     # fill_in 'username', with: 'test'
#     # fill_in 'password', with: 'test'
#     # # end
#     # click_on('submit')
#     # expect(page).to have_title('UC Berkeley GeoData Repository')
#   end
# end
