class Restaurant < ApplicationRecord

  def new
    @restaurant = Restaurant.new
    @restaurant.name = scrapping
    @restaurant.address = scrapping
    @restaurant.ranking = scrapping
  end
end
