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
        RestaurantRemote.new({
          url: resto["url"],
          name: resto["name"],
          food_type: resto["food_tags"].join(', '),
          price_fork: resto["price_category_symbols"],
          delivery_time: resto["time"].strip,
          photo_url: resto["image_url"]
        })
      end
    end

    def find(url)


      response = RestClient.get ('https://deliveroo.fr/fr/') + url
      n_html = Nokogiri::HTML.parse(response)

      deliveroo_restaurant_menu = []

      # Category title and description into an aray of hashes :

      # Récupère un aray de titres de catégoruies :
      scraped_titles = n_html.search('.results-group .results-group-title').map(&:text).map(&:strip)

      # Aray de titres sur lequel on itère ensuite en fonction de l'index... :
      scraped_titles.each_with_index do |title, index|

        # Récupère la liste de tous les plats en fonction de l'index de la catégorie dans l'aray :
        dishes_list = n_html.search('.results-list')[index]

        # Récupère le titre du plat :
        name = dishes_list.search('.list-item-title').first.text.strip

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

      deliveroo_restaurant_menu
    end
  end
end
