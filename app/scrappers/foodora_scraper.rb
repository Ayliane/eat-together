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
    foodora_url = RestClient.get url
    scrap = Nokogiri::HTML.parse(foodora_url)
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
        price_fork: resto['price'],
        food_characteristics: food_characteristics,
        food_type: resto['characteristics']['primary_cuisine']['name'],
      }
    end
    @foodora_restaurants.select do |resto|
      resto[:food_characteristics].include?(@food_type) || resto[:food_type].include?(@food_type)
    end
  end

  def self.get_scrap_from_show

  end

  def self.scrap_show

  end

end

