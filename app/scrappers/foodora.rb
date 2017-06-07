class Foodora
  attr_reader :logo_url, :foodora_restaurant_menu, :restaurant_remote

  def self.host_for(address)
    results = Geocoder.search(address)
    mini_address = { post_code: results.first.postal_code, city: results.first.city, street: results.first.street_address }
    latitude = results.first.latitude.to_s
    longitude = results.first.longitude.to_s
    URI.encode("https://www.foodora.fr/restaurants/lat/#{latitude}/lng/#{longitude}/plz/#{mini_address[:post_code]}/city/#{mini_address[:city]}/address/#{mini_address[:street]}")
  end

  def where(params)
    parsed_html = request_index_page_with(params)
    scrap_restaurants_from(parsed_html, params)
  end

  def request_index_page_with(params)
    response = RestClient.get("#{params[:url]}")
    Nokogiri::HTML.parse(response).search('.vendor-list.opened li a')
  end

  def scrap_restaurants_from(n_html, params)
    @food_choice = params[:food_type]
    @foodora_restaurants = []
    results_scrap = n_html.map do |obj|
      data_hash = JSON.parse(obj.attribute('data-vendor'))
      price = obj.search('.categories li').first.text.strip
      data_hash['price'] = price
      data_hash
    end

    results_scrap.each do |resto|
      food_characteristics = resto['characteristics']['cuisines']
      food_characteristics = food_characteristics.map { |type|  type['name'] }

      @foodora_restaurants << RestaurantRemote.new({
        url: resto['web_path'],
        name: resto['name'],
        address: resto['address'],
        delivery_time: resto['minimum_delivery_time'],
        photo_url: resto['image_high_resolution'],
        price_fork: resto['price'],
        food_characteristics: food_characteristics.join(', '),
        food_type: resto['characteristics']['primary_cuisine']['name'],
      })
    end

    @foodora_restaurants.select do |resto|
      resto.food_type.include?(RestaurantRemote::CATEGORIES[@food_choice.downcase.to_sym])
    end
  end

  def find(url)
    response = RestClient.get url
    n_html = Nokogiri::HTML.parse(response)

    @restaurant_remote = RestaurantRemote.new({
      logo_url: n_html.search('.menu__categories__vendor-logo-img').attr('src').value,
      name: n_html.search('.hero-menu__info__headline').text.strip,
      description: n_html.search('.hero-menu__info__description').text,
      address: n_html.search('.hero-menu__info-extra__address').first.attr('data-street')
    })

    @foodora_restaurant_menu = {}

    scraped_categories = n_html.search('.menu__items .dish-category-header').css('h2').map(&:text)

    scraped_categories.each do |category|
      @foodora_restaurant_menu[category] = []
    end

    scraped_categories.each_with_index do |category, index|

      dish_lists = n_html.search('.menu__items .dish-list')[index].search('li').each do |div|

        dish_card = div.search('div.dish-card').first
        dish_hash = JSON.parse(dish_card.attribute('data-object'))

        @foodora_restaurant_menu[category] << {
          name: dish_hash['name'],
          description: dish_hash['description'],
          price: dish_hash['product_variations'].first['price'],
        }
      end
    end
  end
end
