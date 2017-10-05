# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  name       :string
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
	factory :item do
		name { Faker::Commerce.product_name }
		price { BigDecimal.new(Faker::Commerce.price.to_s) }
	end
end