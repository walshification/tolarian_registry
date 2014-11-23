require "tolarian_registry/version"
require 'unirest'

module TolarianRegistry
  class Registry
    attr_accessor :card, :set, :multiverse_id

    def initialize(hash)
      # @card = hash["name"]
      # @set = hash["editions"]["set"]
      @multiverse_id = hash[:multiverse_id]
    end

    def low_price
      @card = Unirest.get("https://api.deckbrew.com/mtg/cards?multiverseid=#{@multiverse_id}").body
      @card["editions"].each do |edition|
        @price = edition["price"]["low"] if edition["multiverse_id"] == @multiverse_id
      end
    end

    def avg_price
      @card = Unirest.get("https://api.deckbrew.com/mtg/cards?multiverseid=#{@multiverse_id}").body
      @card["editions"]["price"]["average"]
    end

    def high_price
      @card = Unirest.get("https://api.deckbrew.com/mtg/cards?multiverseid=#{@multiverse_id}").body
      @card["editions"]["price"]["high"]
    end

  end
end
