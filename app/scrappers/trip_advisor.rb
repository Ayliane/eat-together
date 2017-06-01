class TripAdvisor

  def scrap
    @current_page = RestClient.get 'https://www.tripadvisor.fr/Restaurants-g187265-Lyon_Rhone_Auvergne_Rhone_Alpes.html'
    @current_page = Nokogiri::HTML.parse(@current_page)
    @results = []
    # binding.pry
    while has_next_page?
      extract_url
      # binding.pry
      scrap_show
      # binding.pry
      @current_page = RestClient.get next_page_url
      @current_page = Nokogiri::HTML.parse(@current_page)
      # binding.pry
    end
    @results
  end

  private

  def has_next_page?
    # @current_page.search('[data-page-number]').last.
    # Doit aller chercher le numéro de la last page et le comparer au numéro du current page et renvoyer un boolean.
    end_page_number = @current_page.search('[data-page-number]').last.attr('data-page-number').to_i
    current_page_number = @current_page.search('.pageNum.current').attr('data-page-number').value.to_i
    puts "page number : #{current_page_number}"
    current_page_number < end_page_number
  end

  def next_page_url
    # Get next url in pagination links
    # @current_page.search('')
    # /Restaurants-g187265-oa30-Lyon_Rhone_Auvergne_Rhone_Alpes.html#EATERY_LIST_CONTENTS
    next_page = @current_page.search('.nav.next').attr('href').value
    return 'https://www.tripadvisor.fr' + next_page
  end

  def extract_url
    # Add url to show page for restaurant in an aray
    @urls = []
    @current_page.search('.property_title').each do |resto|
      @urls << resto.attribute('href')
    end
    @urls = @urls.map { |rest| rest.value }
  end

  def scrap_show
    @urls.each do |url|

      if does_not_exists?(url)


        puts "Scrapping #{url}"
        sleep(1)
        complete_url = RestClient.get ("https://www.tripadvisor.fr" + url)
        scrapping = Nokogiri::HTML.parse(complete_url)
        binding.pry if scrapping.search('#HEADING').nil?
        resto = Restaurant.create!(
          name: scrapping.search('#HEADING').text.strip,
          address: scrapping.search('.street-address').first.text,
          ranking: scrapping.search('.ui_bubble_rating').first.attribute('content').text.gsub(/,/, '.').to_f,
          cook_rank: scrapping.search('.barChart .ui_bubble_rating').first.attribute('alt').value.split(' ').first.to_f,
          value_balance: scrapping.search('.barChart .ui_bubble_rating').first.attribute('alt').value.split(' ').first.to_f,
          url: url
        )
        puts "Created #{}"
      end
    end
  end

  def does_not_exists?(url)

  end
end



