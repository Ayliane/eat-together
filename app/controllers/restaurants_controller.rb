class RestaurantsController < ApplicationController

  def index
    # Cette méthode est vide, c'est normal, les requêtes seront faites par Ajax :)
    set_deliveroo_host
    redirect_to deliveroo_path
  end

  def deliveroo
    list = DeliverooScraper.new(url: session[:deliveroo_url])
    @restaurants = list.scrap
  end

  def foodora
    list = FoodoraScraper.new("delivery_address", "food_type")
    @foodora_restaurants = list.scrap
  end

  private


  # Cette méthode permet de set l'adresse à utiliser pour le scraping de l'index :)
  def set_deliveroo_host
    address = params[:address]
    ds = DeliverooScraper.new(address: address)
    session[:deliveroo_url] = ds.host
  end

  # Cette méthode permet de set l'adresse à utiliser pour le scraping de l'index :)
  def set_foodora_host

  #   foodora_scrapper = FoodoraScraper.new("address_utilisateur", "food_style")
  #   session["foodora_host"] = foodora_scrapper.host
  end

  def restaurant_params
    params.require(:restaurants).permit(:address, :url)
  end

end

