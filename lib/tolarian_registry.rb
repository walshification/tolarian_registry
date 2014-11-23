require "tolarian_registry/version"

module TolarianRegistry
  class Registry
    attr_accessor :card, :set

    def initialize(options = {})
      @card = options || ''
      @set = options || ''
    end

    def tcgplayer_price(card, set)
      @card = Unirest.get("http://magictcgprices.appspot.com/api/tcgplayer/price.json?cardname=#{card}&cardset=#{set}").body
    end

    def cfb_price(card, set)
      @card = Unirest.get("http://magictcgprices.appspot.com/api/cfb/price.json?cardname=#{card}&cardset=#{set}").body
    end

    def ebay_price(card, set)
      @card = Unirest.get("http://magictcgprices.appspot.com/api/ebay/price.json?cardname=#{card}&cardset=#{set}").body
    end
  end
end
