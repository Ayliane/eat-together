happy_seeds = TripAdvisor.new.scrap

puts "Creating seeds"


i = 0

hashy_seeds.each do |elem|
  Restaurant.create!(name: elem[:name], address: elem[:address], ranking: elem[:ranking])
  i += 1
  puts "Seed #{i} ok"
end
