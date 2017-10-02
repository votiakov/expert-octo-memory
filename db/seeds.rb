# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
[
	{ name: 'Smart Hub', price: 49.99 },
	{ name: 'Motion Sensor', price: 24.99 },
	{ name: 'Wireless Camera', price: 99.99 },
	{ name: 'Smoke Sensor', price: 19.99 },
	{ name: 'Water Leak Sensor', price: 14.99 }
].each do |item|
	Item.where(name: item[:name]).first_or_create(price: item[:price])
end