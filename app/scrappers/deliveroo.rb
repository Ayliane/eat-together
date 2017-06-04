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

      # Récupère un aray de titres de catégoruies :
      scraped_titles = scrap.search('.results-group .results-group-title').map(&:text).map(&:strip)

      # Aray de titres sur lequel on itère ensuite en fonction de l'index... :
      scraped_titles.each_with_index do |title, index|

        # Récupère la liste de tous les plats en fonction de l'index de la catégorie dans l'aray :
        dishes_list = scrap.search('.results-list')[index]

        # Récupère le titre du plat :
        name = dishes_list.search('.list-item-title').first.text.strip => Marguerita

        # Récupère la description du plat :
        description = dishes_list.search('.list-item-description').first.text.strip

        # Récupère le prix du plat :
        price = dishes_list.search('.item-price').first.search('span').first.search('span').text


        @deliveroo_restaurant_menu << {
          category_title: title,
          data: {
            name: name,
            description: description,
            price: price
          }
        }
      end
      @deliveroo_restaurant_menu
    end
  end
end
