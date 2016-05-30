# :nodoc:
module PlayStation
  # This class uses PlayStation store json api to retrive list of games
  class Store
    include Enumerable
    URL      = 'https://store.playstation.com'.freeze
    PER_PAGE = 30
    attr_reader :page, :games

    def initialize
      @api = Faraday.new(url: URL) do |faraday|
        faraday.use :http_cache, store: Rails.cache
        faraday.adapter Faraday.default_adapter
        faraday.response :json
      end
      @page  = 0
      @games = []
    end

    # Fetch next page with games
    # @return true if fetched any games
    def next
      response = @api.get("/chihiro-api/viewfinder/PL/en/19/STORE-MSF75508-PS4CAT?game_content_type=games&platform=ps4&size=#{PER_PAGE}&gkb=1&geoCountry=PL&start=#{offset}&sort=name&direction=as")
      @games   = response.body['links'].map { |raw_json_game| PlayStation::Game.new(raw_json_game) }
      @page += 1
      !@games.blank?
    end

    def each(*)
      @page = 0
      @games.each { |game| yield(game) } while self.next
    end

    private

    def offset
      @page * PER_PAGE
    end
  end
end
