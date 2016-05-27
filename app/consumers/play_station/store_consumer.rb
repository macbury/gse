# :nodoc:
module PlayStation
  # This class uses PlayStation store json api to retrive list of games
  class StoreConsumer
    include Enumerable
    URL = 'https://store.playstation.com'.freeze
    attr_reader :page, :games

    def initialize
      @api = Faraday.new(url: URL) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.response :json
      end
      @page  = 0
      @games = []
    end

    # Fetch next page with games
    # @return true if fetched any games
    def next
      @page += 1
      response = @api.get("/chihiro-api/viewfinder/PL/en/19/STORE-MSF75508-PS4CAT?game_content_type=games&platform=ps4&size=30&gkb=#{@page}&geoCountry=PL")
      @games   = response.body['links'].map { |raw_json_game| PlayStation::Game.new(raw_json_game) }
      !@games.blank?
    end

    def each(*)
      @page = 0
      @games.each { |game| yield(game) } while self.next
    end
  end
end
