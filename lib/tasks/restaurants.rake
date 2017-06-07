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

  desc "Update nul ranking to nil"
  task :ranking => :environment do
    puts "Changing nul ranks to nil"
    nul_rank_list = Restaurant.where("ranking = -1.0")
    number = nul_rank_list.count
    nul_rank_list.each { |restaurant| restaurant.update(ranking: nil) }
    puts "Ranking : #{number} changes done"
  end

  desc "Update nul cook_rank to nil"
  task :cookrank => :environment do
    puts "Changing nul ranks to nil"
    nul_cook_rank_list = Restaurant.where("cook_rank = 0.0")
    number = nul_cook_rank_list
    nul_cook_rank_list.each { |restaurant| restaurant.update(cook_rank: nil) }
    puts "Cook rank : #{number} changes done"
  end

  desc "Update nul value_balance to nil"
  task :valuebalance => :environment do
    puts "Changing nul ranks to nil"
    nul_value_balance_list = Restaurant.where("value_balance = 0.0")
    number = nul_value_balance_list
    nul_value_balance_list.each { |restaurant| restaurant.update(value_balance: nil) }
    puts "Value balance : #{number} changes done"
  end
end
