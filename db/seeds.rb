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


Promotion.where(code: '20%OFF').first_or_create(value: 20.0, kind: :percent)
Promotion.where(code: '5%OFF').first_or_create(value: 5.0, kind: :percent, can_combine: true)
Promotion.where(code: '20POUNDSOFF').first_or_create(value: 20.0, kind: :amount, can_combine: true)

Promotion.create(item_id: Item.find_by_name('Motion Sensor').id, value: 65.0, kind: :product, can_combine: true, quantity: 3)
Promotion.create(item_id: Item.find_by_name('Smoke Sensor').id, value: 35.0, kind: :product, can_combine: true, quantity: 2)
