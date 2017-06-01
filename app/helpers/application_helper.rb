module ApplicationHelper
  def food_types
    RestaurantRemote::CATEGORIES.map do |key, value|
      key.capitalize
    end
  end
end
