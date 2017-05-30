require 'json'

class RestaurantsController < ApplicationController
  # before_action :set_deliveroo_host

  def index
    # Cette méthode est vide, c'est normal, les requêtes seront faites par Ajax :)
  end

  def deliveroo
    list = DeliverooScraper.new("delivery_address", "food_type")
    @restaurants = list.scrap
  end

  def foodora
    # list = FoodoraScraper.new("delivery_address", "food_type")
    # @foodora_restaurants = list.scrap
    @foodora_restaurants = JSON.parse(File.open('vendor/fixtures/foodora.json').read).map do |hash|
      hash.with_indifferent_access
    end
    render :layout => false
  end

  private


  # Cette méthode permet de set l'adresse à utiliser pour le scraping de l'index :)
  def set_deliveroo_host
  #   deliveroo_scrapper = DeliverooScraper.new("address_utilisateur", "food_style")
  #   session["deliveroo_host"] = deliveroo_scrapper.host
  end

  # Cette méthode permet de set l'adresse à utiliser pour le scraping de l'index :)
  def set_foodora_host
  #   foodora_scrapper = FoodoraScraper.new("address_utilisateur", "food_style")
  #   session["foodora_host"] = foodora_scrapper.host
  end

end
