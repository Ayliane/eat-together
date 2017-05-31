happy_seeds = TripAdvisor.new.scrap

puts "Creating seeds"

hashy_seeds.each do |elem|
  Restaurant.create!(name: elem[:name], address: elem[:address], ranking: elem[:ranking])
  puts "Seed ok"
end
