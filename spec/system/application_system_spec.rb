require 'rails_helper'

RSpec.describe 'View Restricted Data', type: :system do
  # before do
  #   driven_by(:rack_test)
  # end

  # before do
  #   driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: {
  #     browser: :remote,
  #     url: 'http://selenium.test:4444'
  #   }
  # end

  it 'can view restricted data' do
    visit '/catalog/berkeley-s7b12n'
    expect(page).to have_text('Login to View and Download')
  end
end
