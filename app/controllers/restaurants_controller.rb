require 'json'

class RestaurantsController < ApplicationController

  def index
    set_deliveroo_host
    set_foodora_host
    # Ce chemin renvoie sur deliveroo_path pour tester
  end

  def deliveroo
    # Ici le code n'est pas final : cela fonctionne pour tester
    # mais il faudra séparer ces requêtes dans différentes méthodes
    # car une partie d'entre elles seront déclenchées par la requête ajax
    # plutôt que dans cette méthode !
    # host = DeliverooScraper.new(address: params[:address]).host

    @deliveroo_restaurants = DeliverooScraper.new(url: session[:deliveroo_url], food_type: params[:food_type]).scrap
    # list = DeliverooScraper.new(url: params[:url], food_type: params[:food_type])
    # list = DeliverooScraper.new(url: session[:host], food_type: params[:food_type])
    # @deliveroo_restaurants = list.scrap
    render :layout => false if request.xhr?
  end

  def foodora
    # host = FoodoraScraper.new(address: params[:address]).host

    @foodora_restaurants = FoodoraScraper.new(url: session[:foodora_url], food_type: params[:food_type]).scrap
    # @foodora_restaurants = JSON.parse(File.open('vendor/fixtures/foodora.json').read).map do |hash|
    #   hash.with_indifferent_access
    # end
    render :layout => false if request.xhr?
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
    address = params[:address]
    ds = FoodoraScraper.new(address: address)
    session[:foodora_url] = ds.host
  #   foodora_scrapper = FoodoraScraper.new("address_utilisateur", "food_style")
  #   session["foodora_host"] = foodora_scrapper.host
  end

  def restaurant_params
    params.require(:restaurants).permit(:address, :url)
  end

end

