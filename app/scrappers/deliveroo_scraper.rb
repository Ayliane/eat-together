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
  end

  def self.get_scrap_from_show

  end

  def self.scrap_show

  end
end

  # Pour le each
    # @restaurants_list = []
    # @scraping_index.search('.js-react-on-rails-component').each do |resto|
    #   @restaurants_list << {
    #     url: "",
    #     name: "",
    #     food_type: "",
    #     price_fork: "",
    #     delivery_time: "",
    #     photo_url: ""
    #   }



# # Création du tableau de hashs contenant chaque card de resto
#  @resto_url = []
#     scraping.search('.restaurant-index-page--grid-row').each do |resto|
#       @resto_url << resto


#     # Récupérer tableau de liens de restaurants
#     scraping.search('.property_title').each do |resto|
#       @resto_url << resto.attribute('href')
#     end

#     # Tableau des liens sans le préfixe https://www.tripadvisor.fr/
#     @resto_url = @resto_url.map { |rest| rest.value }

# @resto_url.each do |url|
#     sleep(1)
#     complete_url = RestClient.get ("https://www.tripadvisor.fr" + url)
#     scraping = Nokogiri::HTML.parse(complete_url)
#     results << {
#       name: scraping.search('#HEADING').text.strip,
#       address: scraping.search('.street-address').first.text,
#       ranking: scraping.search('.ui_bubble_rating.bubble_45').first.attribute('content').text.gsub(/,/, '.').to_f
#     }

# end
