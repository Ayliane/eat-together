class RestaurantRemote

  CATEGORIES = {french: "Français", burgers: "Burgers", american: "Américain", thai: "Thai", international: "International", vegan: "Végétarien", bagels: "Bagels", asian: "Asiatique", italian: "Italien", indian: "Indien", tacos: "Tacos",
                vietnamese: "Vietnamien", sushi: "Sushi", pizza: "Pizza"}

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
