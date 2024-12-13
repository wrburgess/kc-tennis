# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# CREATE Admins
puts "BEGIN: Create admins"
admins = [
  { email: "wrburgess@gmail.com", first_name: "Randy", last_name: "Burgess", password: "dtf6fhu7pdq6nbz-RED", confirmed_at: Time.now.utc }
]
admins.each do |admin|
  User.create_with(admin).find_or_create_by(email: admin[:email])
end
puts "END:   Create admins, Users Count: #{User.count}"

# CREATE Admins
puts "BEGIN: Create users"
admins = [
  { email: "wrburgess@gmail.com", first_name: "Randy", last_name: "Burgess", password: "dtf6fhu7pdq6nbz-RED", confirmed_at: Time.now.utc }
]
[1..30].each do |admin|
  User.create(
    email: Faker::Internet.email,
    first_name: Faker::Person.first_name,
    last_name: Faker::Person.last_name,
    password: Faker::Internet.password,
    confirmed_at: Time.now.utc
  )
end
puts "END:   Create users, Users Count: #{User.count}"

# CREATE Links
puts "BEGIN: Create Links"

[1..30].each do
  Link.create(url: Faker::Internet.url, url_type: UrlTypes.all.sample, secure_code: SecureRandom.hex(10), notes: Faker::Lorem.sentence)
end
puts "END:   Create Links, Links Count: #{Link.count}"
