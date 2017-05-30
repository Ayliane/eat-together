class DeliverooScraper
  attr_accessor :address, :food_type, :scraping_index, :url

  def initialize(args)
    @address = args[:address]
    @food_type = args[:food_type]
    @url = args[:url]
    @url.blank? ? "" : @scraping_index = get_scrap_from_index(@url)
  end

  def scrap
    scrap_index_by_location
  end

  def host
    results = Geocoder.search("#{address}")
    coordinates = results.first.coordinates.reverse
    response = RestClient.post "https://deliveroo.fr/fr/api/restaurants", {"location":{"coordinates": coordinates }}, {content_type: "application/json"}
    ok_response = JSON.parse(response.body)
    "https://deliveroo.fr" + ok_response['url']
  end

  private

  def get_scrap_from_index(stored_url)
    ok_url = RestClient.get "#{stored_url}"
    scrap = Nokogiri::HTML.parse(ok_url)
    scrap.search(".js-react-on-rails-component")
  end

  def scrap_index_by_location
    @restaurants_list = []
    results_scrap = @scraping_index.attribute('data-props')
    results_json = JSON.parse(results_scrap)
    results_json["restaurants"].each do |resto|
      @restaurants_list << {
        url: resto["url"],
        name: resto["name"],
        food_type: resto["food_tags"],
        price_fork: resto["price_category_symbols"],
        delivery_time: resto["time"],
        photo_url: resto["image_url"]
      }
    end
    @restaurants_list
  end

  def self.get_scrap_from_show

  end

  def self.scrap_show

  end
end
