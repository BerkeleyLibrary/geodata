require 'rails_helper'
require 'uri'

RSpec.feature 'Clicking login link on home page', type: :feature do
  scenario 'User clicks login link and goes redirected login page' do
    visit root_path
    click_on('Login')
    url = '/cas/login?service=http%3A%2F%2Fapp.test%3A3000%2Fusers%2Fauth%2Fcalnet%2Fcallback%3Furl%3Dhttp%253A%252F%252Fapp.test%253A3000%252F'
    expect(page).to have_current_path(url)
  end
end

RSpec.feature 'Homepage', type: :feature, js: true do
  include Capybara::DSL
  scenario 'User visits the homepage' do
    visit root_path
    expect(page).to have_title('UC Berkeley GeoData Repository')
  end
end
