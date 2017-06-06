class Api::V1::RestaurantsController < Api::V1::BaseController

  def index
    @restaurants = Restaurant.all
  end

  def show
    if @restaurant = Restaurant.find_by(name: params[:name])
       @restaurant = Restaurant.find_by(name: params[:name])
    else
        render json: {message: params[:name] + " ne se trouve pas dans la db"}
    end
  end

end
