class RestaurantRemote

  CATEGORIES = {french: "Français", burgers: "Burgers", american: "Américain", thai: "Thai", international: "International", vegan: "Végétarien", bagels: "Bagels", asian: "Asiatique", italian: "Italien", indian: "Indien", tacos: "Tacos",
                vietnamese: "Vietnamien", sushi: "Sushi", pizza: "Pizza"}

  attr_accessor :name, :delivery_time, :address, :photo_url, :price_fork, :food_type, :food_characteristics, :url, :global_rank, :cook_rank, :quality_rank

  def initialize(args)
    @name = args[:name]
    @address = args[:address]
    @photo_url = args[:photo_url]
    @price_fork = args[:price_fork]
    @food_type = args[:food_type]
    @food_characteristics = args[:food_characteristics]
    @delivery_time = args[:delivery_time]
    @url = args[:url]
    @global_rank = global_ranking
    @cook_rank = cook_ranking
    @quality_rank = quality_ranking
  end

  def global_ranking
    if Restaurant.find_by(address: @address) == nil
      return "N/A"
    else
      @restaurant = Restaurant.find_by(address: @adress)
      @restaurant.ranking
    end
  end

  def cook_ranking
  end

  def quality_ranking

  end
end
