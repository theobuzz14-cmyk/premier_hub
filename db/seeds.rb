# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Team.destroy_all

teams = [
  { name: "Arsenal" }, { name: "Aston Villa" }, { name: "Bournemouth" },
  { name: "Brentford" }, { name: "Brighton & Hove Albion" }, { name: "Chelsea" },
  { name: "Crystal Palace" }, { name: "Everton" }, { name: "Fulham" }, { name: "Liverpool" },
  { name: "Manchester City" }, { name: "Manchester United" }, { name: "Newcastle United" },
  { name: "Nottingham Forest" }, { name: "Tottenham Hotspur" }, { name: "West Ham United" },
  { name: "Wolverhampton Wanderers" },
  # 2025-26 昇格組
  { name: "Sunderland" }, { name: "Burnley" }, { name: "Leeds" }
].uniq # 重複を防ぐため

# (中略) 残りの保存ロジック

teams.each do |team_data|
  # logo_url に仮の値を入れます（バリデーションを通すため）
  Team.create!(
    name: team_data[:name],
    logo_url: "https://example.com/logo.png" 
  )
end

puts "Successfully created #{Team.count} teams!"