require 'rails_helper'

RSpec.describe 'Catalog tracking', type: :request do
  it 'returns no content for GET requests to Blacklight tracking URLs' do
    get '/catalog/stanford-bh565zz1424/track'

    expect(response).to have_http_status(:no_content)
    expect(response.headers['X-Robots-Tag']).to eq('noindex, nofollow')
  end

  it 'keeps POST requests routed to Blacklight search tracking' do
    post '/catalog/stanford-bh565zz1424/track', params: { counter: 2, document_id: 'stanford-bh565zz1424' }

    expect(response).to have_http_status(:see_other)
    expect(response).to redirect_to('/catalog/stanford-bh565zz1424')
  end
end
