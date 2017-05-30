# Pour appeler le scrapper de l'index :
# list = DeliverooScraper.new("delivery_address", "food_type")
# @restaurants = list.scrap

class DeliverooScraper
  attr_accessor :address, :food_type, :scraping_index
  def initialize(address, food_type)
    @address = address
    @food_type = food_type
    @scraping_index = get_scrap_from_index
  end

  def scrap
    scrap_index_by_location
  end

  private

  def host # <-- cette méthode doit servir à fabriquer l'url de l'adresse user sur deliveroo :)
    # ATTENTION !!
    # Prévoir dans le controller restaurant_remote un before_action :set_deliveroo_host
    # Qui prendra def set_deliveroo_host
    # ds = DeliverooScrapper.new(address)
    # session["deliveroo_host"] = ds.host
    # end
  end

  def get_scrap_from_index
    # Sélectionne la page à scrapper
    url = RestClient.get 'https://deliveroo.fr/fr/restaurants/lyon/villeurbanne-grange-blanche?geohash=u05kpp8cp7m3'
    # remplacer l'url par self.host =)

    # Parser la page sélectionnée
    scrap = Nokogiri::HTML.parse(url)
    scrap.search(".js-react-on-rails-component")
  end

  def scrap_index_by_location
    @restaurants_list = []
    results_scrap = @scraping_index.attribute('data-props')
    results_json = JSON.parse(results_scrap)
    results_json["restaurants"].each do |resto|
      @restaurants_list << {
        url: resto["url"],
        name: resto["name"],
        food_type: resto["food_tags"],
        price_fork: resto["price_category_symbols"],
        delivery_time: resto["time"],
        photo_url: resto["image_url"]
      }
    end
    @restaurants_list
  end

  def self.get_scrap_from_show

  end

  def self.scrap_show

  end
end
