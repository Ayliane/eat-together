class RestaurantsController < ApplicationController
  before_action :set_deliveroo_host
  before_action :set_foodora_host

  def index

  end

  def deliveroo
    @restaurants = Deliveroo.where(url: session[:deliveroo_url], food_type: params[:food_type])
    render layout: false if request.xhr?
  end

  def foodora
    @restaurants = Foodora.where(url: session[:foodora_url], food_type: params[:food_type])
    render layout: false if request.xhr?
  end

  def show
  end

  def foodora_show
    # @restaurant = Foodora.where(url: params[:foodora_url])
    # render layout: false if request.xhr?
  end

  def deliveroo_show
    # @restaurant = Deliveroo.where(url: params[:deliveroo_url])
    # render layout: false if request.xhr?
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

end

