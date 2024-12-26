require 'rails_helper'

RSpec.describe 'View Institution Catalog' do
  before do
    visit '/'
    click_link('University of California Berkeley')
  end

  it 'see uc berkeley link' do
    # visit '/catalog?f%5Bschema_provider_s%5D%5B%5D=University+of+California+Berkeley'
    a = find('.page-entries').text.split[-1].to_i
    expect(a).to be > 3
    expect(find('.page-entries')).to have_content('1 - 4 of 4')
    expect(find('.card.facet-limit.blacklight-schema_provider_s.facet-limit-active')).to have_content('University of California Berkeley')

    # expect(page.find_link(href: '/')).first.to be_visible
    # print page.html
    # expect(page.find('svg', title: 'University Of California Berkeley')).to be_visible
    # expect(page).to have_css('blacklight-catalog.blacklight-catalog-index')

    # expect(page).to have_title('UC Berkeley GeoData Repository')
    # Capybara.using_wait_time(10) do
    # expect(page).to have_css('card.facet-limit.blacklight-schema_provider_s.facet-limit-active')
    # end
    # within('.card.facet-limit.blacklight-schema_provider_s.facet-limit-active') do
    # expect(page).to have_css('svg title', text: 'BBB')
    # expect(page).to have_css('svg[aria-label="University Of California Berkeley"] title', text: 'BBB')

    # end
  end
end
