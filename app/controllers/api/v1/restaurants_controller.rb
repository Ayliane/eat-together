class Api::V1::RestaurantsController < Api::V1::BaseController

  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find_by(name: params[:name])
  end

end
