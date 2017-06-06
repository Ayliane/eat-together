class RestaurantRemote
  CATEGORIES = {
    french: "Français",
    burgers: "Burgers",
    american: "Américain",
    thai: "Thai",
    international: "International",
    vegan: "Végétarien",
    bagels: "Bagels",
    asian: "Asiatique",
    italian: "Italien",
    indian: "Indien",
    tacos: "Tacos",
    vietnamese: "Vietnamien",
    sushi: "Sushi",
    pizza: "Pizza"
  }

  attr_accessor(
    :name,
    :delivery_time,
    :address,
    :logo_url,
    :description,
    :photo_url,
    :price_fork,
    :food_type,
    :food_characteristics,
    :url,
    :global_rank,
    :cook_rank,
    :quality_rank
  )

  def initialize(args)
    @name = args[:name]
    @address = args[:address]
    @logo_url = args[:logo_url]
    @description = args[:description]
    @photo_url = args[:photo_url]
    @price_fork = args[:price_fork]
    @food_type = args[:food_type]
    @food_characteristics = args[:food_characteristics]
    @delivery_time = args[:delivery_time]
    @url = args[:url]
    @restaurant = find_restaurant
    @global_rank = global_ranking
    @cook_rank = cook_ranking
    @quality_rank = quality_ranking
  end

  private

  def global_ranking
    @restaurant.present? ? @restaurant.ranking : "N/A"
  end

  def cook_ranking
    @restaurant.present? ? @restaurant.cook_rank : "N/A"
  end

  def quality_ranking
    @restaurant.present? ? @restaurant.value_balance : "N/A"
  end

  def find_restaurant
    Restaurant.find_by('name iLIKE ? OR address iLike ?', "%#{@name}%", "%#{address}%")
  end
end
