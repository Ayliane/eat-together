class RestaurantsController < ApplicationController
  before_action :set_deliveroo_host
  before_action :set_foodora_host

  def index
  end

  def show

  end

  def deliveroo
    restaurants = Deliveroo.new.where(url: session[:deliveroo_url], food_type: params[:food_type])
    @restaurants = open_hour(restaurants)
    render layout: false if request.xhr?
  end

  def foodora
    @restaurants = Foodora.new.where(url: session[:foodora_url], food_type: params[:food_type])
    render layout: false if request.xhr?
  end

  def foodora_show
    scraper = Foodora.new
    scraper.find(params[:url])
    @menu = scraper.foodora_restaurant_menu
    # @restaurant_logo = scraper.logo_url
    @modal_content = scraper.restaurant_remote
    render layout: false
  end

  def deliveroo_show
    @menu = Deliveroo.find(params[:url])
    render layout: false
  end

  private

  def set_deliveroo_host
    session[:deliveroo_url] ||= Deliveroo.host_for(params[:address])
  end

  def set_foodora_host
    session[:foodora_url] ||= Foodora.host_for(params[:address])
  end

  def restaurant_params
    params.require(:restaurants).permit(:address, :url)
  end

  def open_hour(restaurants)
    restaurants.select do |resto|
      !resto.delivery_time.include?(":")
    end
  end

end

