class RestaurantsController < ApplicationController
  before_action :set_deliveroo_host

  def deliveroo_restaurants
    list = DeliverooScraper.new("delivery_address", "food_type")
    @restaurants = list.scrap
  end

  def foodora_restaurants
  end

  def uberats_restaurants
  end

  private


  # Cette méthode permet de set l'adresse à utiliser pour le scraping de l'index :)
  def set_deliveroo_host
  #   deliveroo_scrapper = DeliverooScraper.new("address_utilisateur", "food_style")
  #   session["deliveroo_host"] = deliveroo_scrapper.host
  end

end
