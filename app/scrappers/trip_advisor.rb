class TripAdvisor

  def initialize
    TripAdvisor.scrap_index
  end

  def scrap
    TripAdvisor.scrap_show_one
  end

  def self.scrap_index
    # Sélectionne la page à scrapper
    url = RestClient.get 'https://www.tripadvisor.fr/Restaurants-g187265-Lyon_Rhone_Auvergne_Rhone_Alpes.html'

    # Parser la page sélectionnée
    scrapping = Nokogiri::HTML.parse(url)

    # Création du tableau d'url vide
    @resto_url = []

    # Récupérer tableau de liens de restaurants
    # scrapping.search('.property_title').each do |resto|
    #   @resto_url << resto.attribute('href')
    # end

    @resto_url << scrapping.search('.property_title').first.attribute('href')

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
        ranking: scrapping.search('.ui_bubble_rating.bubble_45').first.attribute('content').text.gsub(/,/, '.').to_f,
        cook_rank: scrapping.search('.barChart.ui_bubble_rating.bubble_45').first.attribute('alt'),
        value_balance: scrapping.search('.barChart.ui_bubble_rating.bubble_45').first.attribute('alt')
      }
    end
    results
  end

  def self.scrap_show_one
    results = []
    resto = @resto_url.first
    complete_url = RestClient.get ("https://www.tripadvisor.fr" + resto)
    scrapping = Nokogiri::HTML.parse(complete_url)
    binding.pry
    results << {
      name: scrapping.search('#HEADING').text.strip,
      address: scrapping.search('.street-address').first.text,
      ranking: scrapping.search('.ui_bubble_rating.bubble_45').first.attribute('content').text.gsub(/,/, '.').to_f,
      cook_rank: scrapping.search('.barChart .ui_bubble_rating').first.attribute('alt').value.split(' ').first.to_f,
      value_balance: scrapping.search('.barChart .ui_bubble_rating').first.attribute('alt').value.split(' ').first.to_f
    }
  end

end



