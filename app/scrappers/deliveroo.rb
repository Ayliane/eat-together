require 'json'

class Deliveroo
  attr_reader :restaurant_remote, :deliveroo_restaurant_menu

  def self.host_for(address)
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
    response = RestClient.get('https://deliveroo.fr/fr/' + url)
    n_html = Nokogiri::HTML.parse(response)

    # Changed css tags for Restaurant Remote since Deliveroo made change in DOM

    @restaurant_remote = RestaurantRemote.new({
      name: n_html.search('.restaurant__name').text,
      description: n_html.search('.restaurant__description').text,
      address: n_html.search('.address').text
    })

    @deliveroo_restaurant_menu = {}

    n_html.search('.results-group').each do |group_html|
      category = group_html.search('.results-group-title').text.strip

      @deliveroo_restaurant_menu[category] = []

      group_html.search('.results-list li').each do |menu_item_html|
        @deliveroo_restaurant_menu[category] << {
          name: menu_item_html.search('.list-item-title').text.strip,
          description: menu_item_html.search('.list-item-description').text.strip,
          price: menu_item_html.search('.item-price').text.strip.gsub(',', '.').to_f
        }
      end
    end
  end
end
