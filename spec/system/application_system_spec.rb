require 'rails_helper'

RSpec.describe 'View Restricted Data', type: :system do
  # before do
  #   driven_by(:rack_test)
  # end

  # it 'can view restricted data' do
  #   visit '/catalog/berkeley-s7b12n'
  #   expect(page).to have_text('Login to View and Download')
  # end

  # before do
  #   driven_by(:selenium, using: :headless_chrome)
  # end

  it 'can view restricted data' do
    visit root_path
    expect(page).to have_text('Login to View and Download')
  end
end
