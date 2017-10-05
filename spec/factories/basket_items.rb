# == Schema Information
#
# Table name: basket_items
#
#  id            :integer          not null, primary key
#  resource_type :string
#  resource_id   :integer
#  basket_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  quantity      :integer
#
# Indexes
#
#  index_basket_items_on_basket_id                      (basket_id)
#  index_basket_items_on_resource_type_and_resource_id  (resource_type,resource_id)
#
FactoryGirl.define do
	factory :basket_item do
		association :basket, factory: :basket
		association :resource, factory: :item

		factory :item_basket_item do
			resource { create(:item) }
		end

		factory :promotion_basket_item do
			resource { create(:promotion) }
		end

		quantity 1
	end
end
