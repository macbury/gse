# :nodoc:
module PlayStation
  # This class uses PlayStation store json api to retrive list of games
  class StoreConsumer
    URL = 'https://store.playstation.com'.freeze
    attr_reader :page

    def initialize
      @api = Faraday.new(url: URL) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.response :json
      end
      @page = 0
    end

    # Fetch next page with games
    # @return list of games
    def next
      @page += 1
      response = @api.get("/chihiro-api/viewfinder/PL/en/19/STORE-MSF75508-PS4CAT?game_content_type=games&platform=ps4&size=30&gkb=#{@page}&geoCountry=PL")
      response.body
      []
    end
  end
end
