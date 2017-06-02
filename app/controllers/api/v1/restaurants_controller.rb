class Api::V1::RestaurantsController < Api::V1::BaseController

  def index
    @restaurants = Restaurant.limit(50)
  end

  def show
    @restaurant = Restaurant.find_by(address: params[:address])
  end

end
