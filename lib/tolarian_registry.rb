require "tolarian_registry/version"
require 'unirest'

module TolarianRegistry
  class Card
    attr_accessor :multiverse_id, :related_card_id, :set_number, :card_name, :search_name, :description, :flavor, :colors, :mana_cost, :converted_mana_cost, :card_set_name, :card_type, :card_subtype, :power, :toughness, :loyalty, :rarity, :artist, :card_set_id, :token, :promo, :rulings, :formats, :released_at

    def initialize(hash)
      @multiverse_id = hash[:multiverse_id]
      api_hash = Unirest.get("https://api.deckbrew.com/mtg/cards?multiverseid=#{@multiverse_id}").body
      @card_name = api_hash["name"]
      @editions = api_hash["editions"]
      @text = api_hash["text"]
      @flavor = api_hash["editions"]["flavor"]
      @colors = api_hash["colors"]
      @mana_cost = api_hash["cost"]
      @converted_mana_cost = api_hash["cmc"]
      @card_set_name = api_hash["editions"]["set"]
      @card_types = api_hash["types"]
      @card_subtypes = api_hash["subtypes"]
      @card_supertypes = api_hash["supertypes"]
      @power = api_hash["power"]
      @toughness = api_hash["toughness"]
      @loyalty = api_hash["loyalty"]
      @rarity = api_hash["editions"]["rarity"]
      @artist = api_hash["editions"]["artist"]
      @card_set_id = api_hash["editions"]["set_id"]
      @rulings = api_hash["rulings"]
      @formats = api_hash["formats"]
      @released_at = api_hash["releasedAt"]
    end

    def self.find_by_name(name)
      card = Unirest.get("https://api.deckbrew.com/mtg/cards/#{name}").body.first
      if card
        multiverse_id = card["id"]
        return Card.new(:multiverse_id => multiverse_id)
      else
        return nil
      end
    end

    def low_price
      @price = get_price("low")
    end

    def median_price
      @price = get_price("median")
    end

    def high_price
      @price = get_price("high")
    end

    private

    def get_price(level)
      @card = Unirest.get("https://api.deckbrew.com/mtg/cards?multiverseid=#{@multiverse_id}").body
      @card[0]["editions"].each do |edition|
        @price = edition["price"][level] if edition["multiverse_id"] == @multiverse_id
      end
      @price
    end

  end
end
