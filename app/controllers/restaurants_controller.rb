class RestaurantsController < ApplicationController
  before_action :set_deliveroo_host
  before_action :set_foodora_host

  def index
    set_foodora_host
  end

  def deliveroo
    @restaurants = Deliveroo.where(url: session[:deliveroo_url], food_type: params[:food_type])
    render layout: false if request.xhr?
  end

  def foodora
    @restaurants = Foodora.where(url: session[:foodora_url], food_type: params[:food_type])
    render layout: false if request.xhr?
  end

  def foodora_show

  end

  def deliveroo_show

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

