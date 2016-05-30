# :nodoc:
module PlayStation
  # This model describes playstation store game
  class Game
    # Title of game
    attr_reader :name
    # Current price of game. Nil if game is not published
    attr_reader :price
    # Description of game, contains small amount of html
    attr_reader :description
    # Id of game in playstation store
    attr_reader :id
    # Relase date of game
    attr_reader :release_date
    # Price of game if user have ps plus membership. It might be nil
    attr_reader :ps_plus_price
    # Url to poster image
    attr_reader :poster_url
    # Array of screenshoots urls
    attr_reader :screenshoots

    def initialize(raw_json = {})
      @id           = raw_json['id']
      @name         = raw_json['name']
      @description  = raw_json['long_desc']
      @release_date = Date.parse(raw_json['release_date'])
      find_best_background_or_poster(raw_json)
      find_screenshoots(raw_json)
      product_desc = raw_json['default_sku']
      find_prices(product_desc) if product_desc.present?
    end

    # Is game published
    def published?
      Date.current >= @release_date
    end

    # Game store url
    def url
      "https://store.playstation.com/#!/en-pl/games/cid=#{@id}"
    end

    # Url to image that can be used for background. If nil then it returns poster_url
    def background_url
      @background_url || @poster_url
    end

    private

    # Find all screenshoots
    def find_screenshoots(raw_json)
      @screenshoots = raw_json['mediaList']['screenshots'].map { |raw_screenshoot| raw_screenshoot['url'] } if raw_json['mediaList'] && raw_json['mediaList'].key?('screenshots')
    end

    # Find best picture for poster
    def find_best_background_or_poster(raw_json)
      raw_json['images'].sort { |a, b| a['type'] <=> b['type'] }.each do |raw_image|
        # most of images with type 9 have nice icon poster.
        @poster_url = raw_image['url'] if raw_image['type'] == 9

        # Type 10 probably used for playstation store background on ps4
        @background_url = raw_image['url'] if raw_image['type'] == 10
      end
    end

    # Find normal price, discount price and ps plus price
    def find_prices(product_desc)
      @price = Money.new(product_desc['price'])

      rewards = product_desc['rewards']
      rewards.each do |json_reward|
        if json_reward['isPlus']
          @ps_plus_price = Money.new(json_reward['price'])
        else
          @price = Money.new(json_reward['price'])
        end
      end
    end
  end
end
