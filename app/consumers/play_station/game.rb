# :nodoc:
module PlayStation
  # This model describes playstation store game
  class Game
    attr_accessor :name, :price, :description, :id, :release_date
    def initialize(raw_json = {})
      @id           = raw_json['id']
      @name         = raw_json['name']
      @description  = raw_json['long_desc']
      @release_date = Date.parse(raw_json['release_date'])
      product_desc  = raw_json['default_sku']

      return if product_desc.blank?
      @price = Money.new(product_desc['price'])
    end

    # Is game published
    def published?
      Date.current >= @release_date
    end
  end
end
