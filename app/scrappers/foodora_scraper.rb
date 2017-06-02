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


  # private

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

    # Sélectionne la page à scrapper
    @foodora_restaurant_url = RestClient.get url
    Nokogiri::HTML.parse(@foodora_restaurant_url)
  end

  def scrap_show(url)

    scrap = get_scrap_from_show(url)

    @foodora_restaurant_menu = []

    # Category title and description into an aray of hashes :

    scraped_titles = scrap.search('.menu__items .dish-category-header').css('h2').map(&:text)

    scraped_titles.each_with_index do |title, index|
      # dishes_list = scrap.search('.menu__items .dish-list').first
      dish_lists = scrap.search('.menu__items .dish-list li').each_with_index do |div, index|

      # dish_lists.each_with_index do |div, index|
        # dish_list = scrap.search('.menu__items .dish-list')[1].search('li').first
        dish_card = div.search('div.dish-card').first
        dish_hash = JSON.parse(dish_card.attribute('data-object'))

        @foodora_restaurant_menu << {
          category_title: title,
          data: {
            name: dish_hash['name'],
            description: dish_hash['description'],
            price: dish_hash['product_variations'].first['price']
          }
        }

      end
    end
    @foodora_restaurant_menu
  end
end

