# :nodoc:
module PlayStation
  # This model describes playstation store game
  class Game
    attr_accessor :name, :price, :description
    def initialize(raw_json = {})
      @name = raw_json['name']
    end
  end
end
