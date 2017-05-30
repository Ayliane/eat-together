require 'json'

class FoodoraScraper
  attr_accessor :address, :food_type, :scraping_index

  def initialize (address, food_type)
    @address = address
    @food_type = food_type
    # @scraping_index = get_scrap_from_index
    @foodora_list = FoodoraScraper.scrap_index_by_location
  end

  def scrap
    scrap_index_by_location
  end

  private

  def host
    # <-- cette méthode doit servir à fabriquer l'url de l'adresse user sur deliveroo :)
    # ATTENTION !!
    # Prévoir dans le controller restaurant_remote un before_action :set_deliveroo_host
    # Qui prendra def set_deliveroo_host
    # ds = DeliverooScrapper.new(address)
    # session["deliveroo_host"] = ds.host
    # end
  end

  def get_scrap_from_index

    # Sélectionne la page à scrapper
    foodora_url = RestClient.get "https://www.foodora.fr/restaurants/lat/45.7693079/lng/4.8372633999999834/plz/69001/city/Lyon/address/19%2520Place%2520Tolozan%252C%252069001%2520Lyon%252C%2520France/Place%2520Tolozan/19"
    # remplacer l'url par self.host

    # Parser la page sélectionnée
    foodora_scraping = Nokogiri::HTML.parse(foodora_url)
    foodora_scraping.search('.vendor-list.opened li a')
  end

  def self.scrap_index_by_location

    foodora_url = RestClient.get "https://www.foodora.fr/restaurants/lat/45.7693079/lng/4.8372633999999834/plz/69001/city/Lyon/address/19%2520Place%2520Tolozan%252C%252069001%2520Lyon%252C%2520France/Place%2520Tolozan/19"
    foodora_scraping = Nokogiri::HTML.parse(foodora_url)

    @foodora_restaurants = []
    binding.pry

    restaurants_data = foodora_scraping.search('.vendor-list.opened li a').map do |obj|
      data_hash = JSON.parse(obj.attribute('data-vendor'))
      price = obj.search('.categories li').first.text.strip
      data_hash['price'] = price
      data_hash
    end

    binding.pry

    restaurants_data.each do |resto|

      address = resto['address'], resto['post_code'], resto['city']['name']
      address = address.join(', ')

      food_characteristics = resto['food_characteristics']
      food_characteristics = food_characteristics.map { |type| type['name']}

      @foodora_restaurants << {
        # comment gérer le fait que les resto soient ouverts ou non ?
        name: resto['name'],
        address: address,
        delivery_time: resto['minimum_delivery_time'],
        photo_url: resto['image_high_resolution'],
        price_fork: resto['price'],
        food_characteristics: food_characteristics,
        food_type: resto['characteristics']['primary_cuisine']['name'],
      }
    end

    @foodora_restaurants
  end
end

