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
	has_many :basket_items


	has_many :items,      through: :basket_items, class_name: 'Item', source: :resource, source_type: "Item"
	has_many :promotions, through: :basket_items, class_name: 'Promotion', source: :resource, source_type: "Promotion"

	# has_many :products,   through: :basket_items, class_name: 'Product', source: :item
	# has_many :promotions, through: :basket_items, class_name: 'Promotion', source: :item

	# has_many :products, through: :basket_items, class_name: -> { products }
	def items_total
		items.map(&:price).reduce(:+) # todo - process product promotions
	end

	def number_of_items
		basket_items.items.map(&:quantity).reduce(:+)
	end

	def total_with_promotions
		amount_discount = promotions.amounts.map(&:value).reduce(:+)
		subtotal = items_total - amount_discount
		promotions.percents.map(&:value).reduce(subtotal) { |sum, el| sum * (1 - el) }
		# [0.5, 0.2, 0.1].reduce(1000) { |sum, el| sum * (1 - el) }

	end
end
