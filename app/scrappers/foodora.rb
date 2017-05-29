# https://deliveroo.fr/fr/restaurants/lyon/villeurbanne-grange-blanche?geohash=u05kpp8cp7m3
# Obtenir le geohash via la gem


class Foodora

  def initialize
    Foodora.scrap_index_by_location
  end

  def self.scrap_index_by_location
    # Sélectionne la page à scrapper
    url = RestClient.get 'https://deliveroo.fr/fr/restaurants/lyon/villeurbanne-grange-blanche?geohash=u05kpp8cp7m3'

    # Parser la page sélectionnée
    scrapping = Nokogiri::HTML.parse(url)

    # Création du tableau de hashs
    @resto_url = []



    # Récupérer tableau de liens de restaurants
    scrapping.search('.property_title').each do |resto|
      @resto_url << resto.attribute('href')
    end

    # Tableau des liens sans le préfixe https://www.tripadvisor.fr/
    @resto_url = @resto_url.map { |rest| rest.value }
  end

end

@resto_url.each do |url|
    sleep(1)
    complete_url = RestClient.get ("https://www.tripadvisor.fr" + url)
    scrapping = Nokogiri::HTML.parse(complete_url)
    results << {
      name: scrapping.search('#HEADING').text.strip,
      address: scrapping.search('.street-address').first.text,
      ranking: scrapping.search('.ui_bubble_rating.bubble_45').first.attribute('content').text.gsub(/,/, '.').to_f
    }
