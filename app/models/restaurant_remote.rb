class RestaurantRemote

  CATEGORIES = ["Français", "Burgers", "Américain", "Thaï", "International", "Végétalien", "Bagels", "Asiatique", "Italien", "Indien", "Tacos",
                "Vietnamien", "Sushi", "Pizza"]

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
