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
      Nokogiri::HTML.parse(response).search('.vendor-list li a')
    end

    def scrap_restaurants_from(n_html, params)
      @food_type = params[:food_type]
      @foodora_restaurants = []
      results_scrap = n_html.map do |obj|
        data_hash = JSON.parse(obj.attribute('data-vendor'))
        price = obj.search('.categories li').first.text.strip
        data_hash['price'] = price
        data_hash
      end

      results_scrap.each do |resto|

        address = resto['address'], resto['post_code'], resto['city']['name']
        address = address.join(', ')
        food_characteristics = resto['characteristics']['cuisines']
        food_characteristics = food_characteristics.map { |type|  type['name'] }

        @foodora_restaurants << {
          name: resto['name'],
          address: address,
          delivery_time: resto['minimum_delivery_time'],
          photo_url: resto['image_high_resolution'],
          price_fork: resto['price'],
          food_characteristics: food_characteristics.join(', '),
          food_type: resto['characteristics']['primary_cuisine']['name'],
        }
      end
      @foodora_restaurants.select do |resto|
        # resto[:food_characteristics].include?(RestaurantRemote::CATEGORIES[@food_type.downcase.to_sym]) || resto[:food_type].include?(RestaurantRemote::CATEGORIES[@food_type.downcase.to_sym])
        resto[:food_type].include?(RestaurantRemote::CATEGORIES[@food_type.downcase.to_sym])
      end
    end
  end
end

