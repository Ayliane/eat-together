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
          delivery_time: resto["time"],
          photo_url: resto["image_url"]
        }.with_indifferent_access
      end
    end
  end
end
