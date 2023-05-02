require 'rails_helper'

# RSpec.describe "Applications", type: :request do
#   describe "GET /index" do
#     pending "add some examples (or delete) #{__FILE__}"
#   end
# end

RSpec.describe 'View Catalog' do
  it 'can view Home Page' do
    get '/'
    expect(response).to be_successful
    expect(response.body).to include('UC Berkeley GeoData Repository')
  end
end
