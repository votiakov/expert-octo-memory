# == Schema Information
#
# Table name: baskets
#
#  id          :integer          not null, primary key
#  checked_out :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Basket < ApplicationRecord
	has_many :basket_items, inverse_of: :basket, dependent: :destroy
	has_one :order


	has_many :items,      through: :basket_items, class_name: 'Item', source: :resource, source_type: "Item"
	has_many :promotions, through: :basket_items, class_name: 'Promotion', source: :resource, source_type: "Promotion"

	def items_total
		basket_items.items.reduce(0) { |sum, item| sum + (item.price * item.quantity) }
	end

	def calculate_product_discounts
		if added_promotion_item_ids && added_promotion_item_ids.size > 0
			discount = 0
			added_promotion_item_ids.each do |item_id|
				pi = PromotionItem.find_by_item_id(item_id)
				bi = basket_items.items.find_by_resource_id(item_id)

				times_apply = bi.quantity / pi.quantity

				discount += times_apply * (pi.quantity * bi.price - pi.value)
			end
			discount
		else
			0
		end
	end

	def added_promotion_item_ids
		promotion_items = PromotionItem.all.map(&:item_id)
		added_items = items.map(&:id)
		promotion_items & added_items
	end

	def number_of_items
		basket_items.items.map(&:quantity).reduce(:+)
	end

	def calculate_amount_discounts
		promotions.amounts.map(&:value).reduce(:+) || 0
	end


	def total_with_promotions
		# subtotal = items_total - calculate_product_discounts
		# amount_discount = promotions.amounts.map(&:value).reduce(:+) || 0
		# subtotal = subtotal - amount_discount
		# promotions.percents.map(&:value).reduce(subtotal) { |sum, el| sum * (1 - el / 100) }

		subtotal = items_total - calculate_product_discounts - calculate_amount_discounts
		if subtotal < 0
			BigDecimal.new('0.1')
		else
			promotions.percents.map(&:value).reduce(subtotal) { |sum, el| sum * (1 - el / 100) }
		end
	end
end
