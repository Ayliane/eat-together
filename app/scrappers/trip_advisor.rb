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

  @resto_url.each do |url|
    sleep(1)
    complete_url = RestClient.get ("https://www.tripadvisor.fr" + url)
    scrapping = Nokogiri::HTML.parse(complete_url)
    results << {
      name: scrapping.search('#HEADING').text.strip,
      address: scrapping.search('.street-address').first.text,
      ranking: scrapping.search('.ui_bubble_rating.bubble_45').first.attribute('content').text.gsub(/,/, '.').to_f
    }
  end
  results
  end
end

