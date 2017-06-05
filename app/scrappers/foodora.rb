class Foodora
  class << self
    def host_for(address)
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

      foodora_restaurant_menu = []

      # Category title and description into an aray of hashes :

      scraped_titles = n_html.search('.menu__items .dish-category-header').css('h2').map(&:text)

      scraped_titles.each_with_index do |title, index|
        # dishes_list = n_html.search('.menu__items .dish-list').first
        dish_lists = n_html.search('.menu__items .dish-list li').each_with_index do |div, index|

        # dish_lists.each_with_index do |div, index|
          # dish_list = n_html.search('.menu__items .dish-list')[1].search('li').first
          dish_card = div.search('div.dish-card').first
          dish_hash = JSON.parse(dish_card.attribute('data-object'))

          foodora_restaurant_menu << {
            category_title: title,
            data: {
              name: dish_hash['name'],
              description: dish_hash['description'],
              price: dish_hash['product_variations'].first['price']
            }
          }

        end
      end

      foodora_restaurant_menu
    end
  end
end
