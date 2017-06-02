module FoodoraHelper
  def first_step(restaurants)
    restaurants.select do |resto|
      resto[:delivery_time] <= 25 && resto[:delivery_time] >= 15
    end
  end

  def second_step(restaurants)
    restaurants.select do |resto|
      resto[:delivery_time] <= 35 && resto[:delivery_time] >= 25
    end
  end

  def third_step(restaurants)
    restaurants.select do |resto|
      resto[:delivery_time] <= 45 && resto[:delivery_time] >= 35
    end
  end
end
