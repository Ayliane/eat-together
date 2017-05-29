class TripAdvisor
  attr_accessor :array

  def initialize
    TripAdvisor.scrap_index
    @array = TripAdvisor.scrap_show

  end

  def self.scrap_index
    # Sélectionne l page à scrapper
    url = RestClient.get 'https://www.tripadvisor.fr/Restaurants-g187265-Lyon_Rhone_Auvergne_Rhone_Alpes.html'

    # Parser la page sélectionnée
    scrapping = Nokogiri::HTML.parse(url)

    # Création du tableau d'url vide
    @resto_url = []

    # Récupérer tableau de liens de restaurants
    scrapping.search('.property_title').each do |resto|
      @resto_url << resto.attribute('href')
    end

    # Tableau des liens sans le préfixe https://www.tripadvisor.fr/
    @resto_url = @resto_url.map { |rest| rest.value }
  end

  def self.scrap_show
    results = []

  semi_url = @resto_url.first
good_url = RestClient.get ('https://www.tripadvisor.fr/' + semi_url)
scrapping = Nokogiri::HTML.parse(good_url)


results << { name: scrapping.search('.heading_name').text.strip, address: scrapping.search('.street-address').text.strip, ranking: scrapping.search('ui_bubble_rating') }

  #   results = []

  #   @resto_url.each do |url|
  #     complete_url = RestClient.get "https://www.tripadvisor.fr/#{url}"
  #     scrapping = Nokogiri::HTML.parse(complete_url)

  #     results << { name: scrapping.search('heading_name'), address: scrapping.search('street-address'), ranking: scrapping.search('ui_bubble_rating') }
  #   end
  #   results
  end
end

