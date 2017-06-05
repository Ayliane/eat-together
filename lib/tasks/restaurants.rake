require 'json'

namespace :restaurants do
  desc "Save restaurants from DB to a json in fixtures"
  task :save => :environment do
    puts "Writing json"
    File.open('vendor/fixtures/restaurants.json', 'w') do |file|
      file.write(Restaurant.all.to_json)
    end
    puts "Done"
  end

  desc "Import restaurants from json in fixtures"
  task :import => :environment do
    restaurants = JSON.parse(File.open('vendor/fixtures/restaurants.json').read)

    restaurants.each do |restaurant|
      Restaurant.create!(
        name: restaurant["name"],
        address: restaurant["address"],
        ranking: restaurant["ranking"],
        cook_rank: restaurant["cook_rank"],
        value_balance: restaurant["value_balance"],
        url: restaurant["url"]
      )
    end
  end
end
