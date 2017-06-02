require 'json'

class RestaurantsController < ApplicationController
  before_action :set_deliveroo_host

  def index
    set_foodora_host
  end

  def deliveroo
    @restaurants = Deliveroo.where(url: session[:deliveroo_url], food_type: params[:food_type])
    render layout: false if request.xhr?
  end

  def foodora
    @foodora_restaurants = FoodoraScraper.new(url: session[:foodora_url], food_type: params[:food_type]).scrap
    render :layout => false if request.xhr?
  end


  private

  def set_deliveroo_host
    session[:deliveroo_url] ||= Deliveroo.host_for(params[:address])
  end

  def set_foodora_host
    address = params[:address]
    ds = FoodoraScraper.new(address: address)
    session[:foodora_url] = ds.host
  end

  def restaurant_params
    params.require(:restaurants).permit(:address, :url)
  end

end

