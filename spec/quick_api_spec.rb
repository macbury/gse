require 'rails_helper'

describe 'Simple api call tester' do
  it 'should fetch information from PS Store' do
    url = 'https://store.playstation.com'

    api = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end

    response = api.get('/chihiro-api/viewfinder/PL/en/19/STORE-MSF75508-PS4CAT?game_content_type=games&platform=ps4&size=30&gkb=1&geoCountry=PL')

    expect(response.body).not_to be_nil
  end
end
