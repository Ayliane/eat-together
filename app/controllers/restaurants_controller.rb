class RestaurantsController < ApplicationController
  before_action :set_deliveroo_host
  before_action :set_foodora_host

  def index
  end

  def show
    @url_left = complete_url(params[:left_url])
    @url_right = complete_url(params[:right_url])
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
    @modal_content = scraper.restaurant_remote
    render layout: false
  end

  def deliveroo_show
    scraper = Deliveroo.new
    scraper.find(params[:url])
    @menu = scraper.deliveroo_restaurant_menu
    @modal_content = scraper.restaurant_remote
    render layout: false
  end

  private

  def set_deliveroo_host
    if params[:address].present?
      session[:deliveroo_url] = Deliveroo.host_for(params[:address])
    else
      session[:deliveroo_url]
    end
  end

  def set_foodora_host
    if params[:address].present?
      session[:foodora_url] = Foodora.host_for(params[:address])
    else
      session[:foodora_url]
    end
  end

  def restaurant_params
    params.require(:restaurants).permit(:address, :url)
  end

  def open_hour(restaurants)
    restaurants.select do |resto|
      !resto.delivery_time.include?(":")
    end
  end

  def complete_url (url)
    if url =~ /foodora/
      url
    else
      "http://deliveroo.fr/fr#{url}"
    end
  end
end

