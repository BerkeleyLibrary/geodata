require 'rails_helper'

RSpec.describe 'Skip map preview keyboard navigation', type: :system do
  it 'keeps map viewer and dynamically added children out of the tab order' do
    view_record(CommonHelpers::PUBLIC_RECORD_ID)
    map = find('[data-controller~="leaflet-viewer"][aria-hidden="true"]', visible: :all)

    page.execute_script(<<~JS, map)
      const map = arguments[0];
      map.insertAdjacentHTML('beforeend', '<div id="map-focus-test"><button type="button">Test</button><a>Link</a></div>');
      map.querySelector('#map-focus-test a').setAttribute('href', '#');
      map.querySelector('#map-focus-test button').addEventListener('click', () => { map.dataset.testClicked = 'true'; });
      map.setAttribute('tabindex', '0');
    JS

    expect(page).to have_css('[data-controller~="leaflet-viewer"][tabindex="-1"]', visible: :all)
    expect(page).to have_css('#map-focus-test button[tabindex="-1"]', visible: :all)
    expect(page).to have_css('#map-focus-test a[tabindex="-1"]', visible: :all)

    page.execute_script("arguments[0].querySelector('#map-focus-test button').click()", map)
    expect(map['data-test-clicked']).to eq('true')
  end
end
