class Api::V1::RestaurantsController < Api::V1::BaseController

  def index
    @restaurants = Restaurant.all
  end

  def show
    restaurants = Restaurant.search(params[:name])

    if restaurants.present?
       @restaurant = restaurants.first
    else
      render json: {message: params[:name] + " ne se trouve pas dans la db"}
    end
  end

end
