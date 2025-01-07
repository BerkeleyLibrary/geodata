require 'rails_helper'

RSpec.describe 'View Institution Catalog' do
  before do
    visit '/'
  end

  it 'view home page title' do
    expect(page).to have_title('UC Berkeley GeoData Repository')
  end

  it 'display UC Berkeley collection link' do
    expect(page).to have_link('University of California Berkeley')
  end

  context 'click UC Berkeley collection link to display UC Berkley collection page' do
    before do
      click_link('University of California Berkeley')
    end

    it 'display record number' do
      expect(find('.page-entries'))

      total_record_num = find('.page-entries').text.split[-1].strip.to_i
      expect(total_record_num).to be > 3
    end

    it 'display active provider - UC Berkeley' do
      expect(find('.card.facet-limit.blacklight-schema_provider_s.facet-limit-active')).to have_content('University of California Berkeley')
    end
  end
end
