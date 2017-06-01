require 'json'

class FoodoraScraper
  attr_accessor :address, :food_type, :scraping_index, :url

  def initialize (args)
    @address = args[:address]
    @food_type = args[:food_type]
    @url = args[:url]
    @url.blank? ? "" : @scraping_index = get_scrap_from_index(@url, @food_type)
    # @scraping_index = get_scrap_from_index
    # @foodora_list = FoodoraScraper.scrap_index_by_location
  end

  def scrap
    get_scrap_from_index(@url, @food_type)
    scrap_index_by_location
  end

  def host
    results = Geocoder.search("#{@address}")
    mini_address = { post_code: results.first.postal_code, city: results.first.city, street: results.first.street_address }
    latitude = results.first.latitude.to_s
    longitude = results.first.longitude.to_s
    URI.encode("https://www.foodora.fr/restaurants/lat/" + latitude +"/lng/" + longitude + "/plz/" + mini_address[:post_code] + "/city/" + mini_address[:city] + "/address/" +  mini_address[:street])
  end


  private

  def get_scrap_from_index(url, food_type)
    # Sélectionne la page à scrapper
    foodora_index_url = RestClient.get url
    scrap = Nokogiri::HTML.parse(foodora_index_url)
    scrap.search('.vendor-list li a')
  end

  def scrap_index_by_location

    @foodora_restaurants = []
    results_scrap = @scraping_index.map do |obj|
      data_hash = JSON.parse(obj.attribute('data-vendor'))
      price = obj.search('.categories li').first.text.strip
      data_hash['price'] = price
      data_hash
    end

    results_scrap.each do |resto|

      address = resto['address'], resto['post_code'], resto['city']['name']
      address = address.join(', ')

      food_characteristics = resto['food_characteristics']
      food_characteristics = food_characteristics.map { |type| type['name']}

      @foodora_restaurants << {
        name: resto['name'],
        address: address,
        delivery_time: resto['minimum_delivery_time'],
        photo_url: resto['image_high_resolution'],
        web_path: resto['web_path'],
        price_fork: resto['price'],
        food_characteristics: food_characteristics,
        food_type: resto['characteristics']['primary_cuisine']['name']
      }
      binding.pry
    end
    @foodora_restaurants.select do |resto|
      resto[:food_characteristics].include?(RestaurantRemote::CATEGORIES[@food_type.downcase.to_sym]) || resto[:food_type].include?(RestaurantRemote::CATEGORIES[@food_type.downcase.to_sym])
    end
  end

  def get_scrap_from_show(url)
    # 19 place Tolozan, Lyon => Guy and Sons Tupin
    # https://www.foodora.fr/restaurant/s2of/guyandsonstupin

    # 2 Place Bellecour, Lyon => Guy and Sons Tupin
    # https://www.foodora.fr/restaurant/s2of/guyandsonstupin

    # 19 place Tolozan, Lyon => Boco Lyon
    # https://www.foodora.fr/restaurant/s8df/boco-lyon

    # 19 place Tolozan, Lyon => Vidici lyon
    # https://www.foodora.fr/restaurant/s3id/vidicilyon

    # Sélectionne la page à scrapper
    @foodora_restaurant_url = RestClient.get url
    scrap = Nokogiri::HTML.parse(foodora_restaurant_url)
    # scrap.search('.vendor-list li a')
  end

  def scrap_show(url)

    get_scrap_from_show(url)

    # @foodora_restaurants = []
    # results_scrap = @scraping_index.map do |obj|
    #   data_hash = JSON.parse(obj.attribute('data-vendor'))
    #   price = obj.search('.categories li').first.text.strip
    #   data_hash['price'] = price
    #   data_hash
    # end

    # results_scrap.each do |resto|

    #   address = resto['address'], resto['post_code'], resto['city']['name']
    #   address = address.join(', ')

    #   food_characteristics = resto['food_characteristics']
    #   food_characteristics = food_characteristics.map { |type| type['name']}

    #   @foodora_restaurants << {
    #     name: resto['name'],
    #     address: address,
    #     delivery_time: resto['minimum_delivery_time'],
    #     photo_url: resto['image_high_resolution'],
    #     url_code: resto['code'],
    #     url_key: resto['url_key'],
    #     price_fork: resto['price'],
    #     food_characteristics: food_characteristics,
    #     food_type: resto['characteristics']['primary_cuisine']['name']
    #   }
    #   binding.pry
    # end
    # @foodora_restaurants.select do |resto|
    #   resto[:food_characteristics].include?(RestaurantRemote::CATEGORIES[@food_type.downcase.to_sym]) || resto[:food_type].include?(RestaurantRemote::CATEGORIES[@food_type.downcase.to_sym])
    # end

  end

end

