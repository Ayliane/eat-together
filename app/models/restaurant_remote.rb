class RestaurantRemote
  attr_accessor :name, :address, :photo_url, :price_fork, :food_type

  def initialize(args)
    @name = args[:name]
    @address = args[:address]
    @photo_url = args[:photo_url]
    @price_fork = args[:price_fork]
    @food_type = args[:food_type]
  end
end
