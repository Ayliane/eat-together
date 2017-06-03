require 'json'

class Deliveroo
  class << self
    def host_for(address)
      coordinates = Geocoder.search(address).first.coordinates.reverse
      data = { location: { coordinates: coordinates }}
      headers =  { content_type: "application/json" }

      response = RestClient.post("https://deliveroo.fr/fr/api/restaurants", data, headers)
      json_response = JSON.parse(response.body)

      "https://deliveroo.fr#{json_response['url']}"
    end

    def where(params)
      parsed_json = request_index_page_with(params)
      scrap_restaurants_from(parsed_json)
    end

    def request_index_page_with(params)
      uri = URI.parse(params[:url])
      uri.path = uri.path + '.json'
      url = uri.to_s
      RestClient.get("#{url}&day=today&time=ASAP&tags=#{params[:food_type]}")
    end

    def scrap_restaurants_from(json)
      response_json = JSON.parse(json)
      response_json['restaurants'].map do |resto|
        {
          url: resto["url"],
          name: resto["name"],
          food_type: resto["food_tags"].join(', '),
          price_fork: resto["price_category_symbols"],
          delivery_time: resto["time"].strip,
          photo_url: resto["image_url"]
        }.with_indifferent_access
      end
    end

    def get_scrap_from_show(url)
      # 19 place Tolozan, Lyon => Guy and Sons Tupin
      # https://deliveroo.fr/fr/menu/lyon/hotel-de-ville/wazza-pizza?day=today&rpos=0&time=ASAP
      # a => href index soit l'url :
      # response_json[:url] = /menu/lyon/hotel-de-ville/wazza-pizza?day=today&rpos=0&time=ASAP

      # 2 Place Bellecour, Lyon => Guy and Sons Tupin
      # https://www.foodora.fr/restaurant/s2of/guyandsonstupin

      # Sélectionne la page à scrapper
      @deliveroo_restaurant_url = RestClient.get ('https://deliveroo.fr/fr/') + url
      Nokogiri::HTML.parse(@deliveroo_restaurant_url)
    end

    def scrap_show(url)

      scrap = get_scrap_from_show(url)

      @deliveroo_restaurant_menu = []

      # Category title and description into an aray of hashes :
      scraped_titles = scrap.search('.results-group .results-group-title').map(&:text).map(&:strip)
      # stock un aray de titres sur lequel on itère ensuite... :

      scraped_titles.each_with_index do |title, index|
        # dish_lists = scrap.search('.results-list').first
        # dish_lists = scrap.search('.results-list')[0].search('li').text

        dish_lists = scrap.search('.results-list').each_with_index do |div, index|

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
      @deliveroo_restaurant_menu
    end
  end
end
