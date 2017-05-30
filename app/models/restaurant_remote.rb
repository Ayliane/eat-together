class RestaurantRemote

  CATEGORIES = ["french", "burgers", "american", "thai", "international", "vegan", "bagels", "asian", "italian", "indian", "tacos",
                "vietnamese", "sushi", "pizza"]

  attr_accessor :name, :delivery_time, :address, :photo_url, :price_fork, :food_type

  def initialize(args)
    @name = args[:name]
    @address = args[:address]
    @photo_url = args[:photo_url]
    @price_fork = args[:price_fork]
    @food_type = args[:food_type]
    @delivery_time = args[:delivery_time]
  end
end
