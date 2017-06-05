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
    if find_restaurant == nil
      "N/A"
    else
      @restaurant = find_restaurant
      @restaurant.ranking
    end
  end

  def cook_ranking
    if find_restaurant == nil
      "N/A"
    else
      @restaurant = find_restaurant
      @restaurant.cook_rank
    end
  end

  def quality_ranking
    if find_restaurant == nil
      "N/A"
    else
      @restaurant = find_restaurant
      @restaurant.value_balance
    end
  end

  private

  def find_restaurant
    Restaurant.find_by('name iLIKE ? OR address iLike ?', "%#{@name}%", "%#{address}%")
  end
end
