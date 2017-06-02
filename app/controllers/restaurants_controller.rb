require 'json'

class RestaurantsController < ApplicationController
  before_action :set_deliveroo_host

  def index
    set_foodora_host
    # Ce chemin renvoie sur deliveroo_path pour tester

    # redirect_to deliveroo_path
  end

  def deliveroo
    @restaurants = Deliveroo.where(url: session[:deliveroo_url], food_type: params[:food_type])

    # to not render layout if request is coming from ajax
    render layout: false if request.xhr?
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
    session[:deliveroo_url] ||= Deliveroo.host_for(params[:address])
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

