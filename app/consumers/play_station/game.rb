# :nodoc:
module PlayStation
  # This model describes playstation store game
  class Game
    attr_accessor :name, :price, :description, :id, :release_date, :images, :ps_plus_price
    def initialize(raw_json = {})
      @id           = raw_json['id']
      @name         = raw_json['name']
      @description  = raw_json['long_desc']
      @release_date = Date.parse(raw_json['release_date'])
      product_desc  = raw_json['default_sku']
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

    private

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
