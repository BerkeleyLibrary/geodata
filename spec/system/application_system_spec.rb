require 'rails_helper'

RSpec.describe 'View Restricted Data', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'can veiw restricted data' do
    visit '/catalog/berkeley-s7b12n'
    expect(page).to have_text('Administrative Boundary Maps of China, 1949-2014')
  end
end
