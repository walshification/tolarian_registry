require "tolarian_registry/version"
require 'unirest'

module TolarianRegistry
  class Card
    attr_accessor :multiverse_id, :card_name, :editions, :text, :flavor, :colors, :mana_cost, :converted_mana_cost, :card_set_name, :card_type, :card_subtype, :power, :toughness, :loyalty, :rarity, :artist, :card_set_id, :image_url, :rulings, :formats

    def initialize(hash)
      @multiverse_id = hash[:multiverse_id]
      deckbrew_hash = Unirest.get("https://api.deckbrew.com/mtg/cards?multiverseid=#{@multiverse_id}").body.first
      mtgdb_hash = Unirest.get("http://api.mtgdb.info/cards/#{@multiverse_id}").body
      @card_name = deckbrew_hash["name"]
      @editions = deckbrew_hash["editions"]
      @text = deckbrew_hash["text"]
      @flavor = deckbrew_hash["editions"][0]["flavor"]
      @colors = deckbrew_hash["colors"]
      @mana_cost = deckbrew_hash["cost"]
      @converted_mana_cost = deckbrew_hash["cmc"]
      @card_set_name = deckbrew_hash["editions"][0]["set"]
      @card_type = mtgdb_hash["type"]
      @card_subtype = mtgdb_hash["subType"]
      @power = deckbrew_hash["power"]
      @toughness = deckbrew_hash["toughness"]
      @loyalty = deckbrew_hash["loyalty"]
      @rarity = deckbrew_hash["editions"][0]["rarity"]
      @artist = deckbrew_hash["editions"][0]["artist"]
      @card_set_id = deckbrew_hash["editions"][0]["set_id"]
      @image_url = deckbrew_hash["editions"][0]["image_url"]
      @rulings = mtgdb_hash["rulings"]
      @formats = mtgdb_hash["formats"]
    end

    def self.find_by_name(name)
      card = Unirest.get("http://api.mtgdb.info/cards/#{name}").body.first
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
