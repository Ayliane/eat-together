require 'json'

class FoodoraScraper
  attr_accessor :array

  def initialize (address, food_type)
    @address = address
    @food_type = food_type
    @foodora_list = FoodoraScraper.scrap_index_by_location
    # @array = Foodora.scrap_show
  end

  def self.scrap_index_by_location

    # Sélectionne la page à scrapper - URL type ci dessous ...
    # "https://www.foodora.fr/restaurants/lat/45.7693079/lng/4.8372633999999834/plz/69001/city/Lyon/address/19%2520Place%2520Tolozan%252C%252069001%2520Lyon%252C%2520France/Place%2520Tolozan/19"
    foodora_url = RestClient.get "https://www.foodora.fr/restaurants/lat/45.7693079/lng/4.8372633999999834/plz/69001/city/Lyon/address/19%2520Place%2520Tolozan%252C%252069001%2520Lyon%252C%2520France/Place%2520Tolozan/19"


    # Parser la page sélectionnée
    foodora_scraping = Nokogiri::HTML.parse(foodora_url)

    restaurants_data = foodora_scraping.search('.vendor-list.opened li a').map do |obj|
      data_hash = JSON.parse(obj.attribute('data-vendor'))
      price = obj.search('.categories li').first.text.strip
      data_hash['price'] = price
      data_hash
    end

    binding.pry
    # Création du tableau d'url vide
    @foodora_restaurants = []

    # Récupérer tableau de liens de restaurants
    # foodora_scrapping.search('.vendor-list').each do |resto|
    #   @foodora_restaurants <<
    # end

    restaurants_data.each do |resto|
      name = resto['name']
      address = resto['address'], resto['post_code'], resto['city']['name']
      address = address.join(', ')
      delivery_time = resto['minimum_delivery_time']
      photo_url = resto['image_high_resolution']
      price_fork = resto['price']
      food_characteristics = resto['food_characteristics']
      food_characteristics = food_characteristics.map { |type| type['name']}
      food_type = resto['characteristics']['primary_cuisine']['name']

      @foodora_restaurants << {
        # comment gérer le fait que les resto soient ouverts ou non ?
        name: name,
        address: address,
        delivery_time: delivery_time,
        photo_url: photo_url,
        price_fork: price_fork,
        food_characteristics: food_characteristics,
        food_type: food_type,
      }
    end

    @foodora_restaurants


    # Tableau des liens sans le préfixe https://www.tripadvisor.fr/
    # @resto_url = @resto_url.map { |rest| rest.value }
  end

  # def self.scrap_show

  # results = []

  # @resto_url.each do |url|
  #   sleep(1)
  #   complete_url = RestClient.get ("https://www.tripadvisor.fr" + url)
  #   scrapping = Nokogiri::HTML.parse(complete_url)
  #   results << { name: scrapping.search('#HEADING').text.strip, address: scrapping.search('.street-address').first.text, ranking: scrapping.search('.ui_bubble_rating.bubble_45').first.attribute('content').text }
  # end
  # results
  # end

end

