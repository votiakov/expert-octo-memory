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

class BasketItem < ApplicationRecord
	attr_accessor :promo_code
	belongs_to :basket
	belongs_to :resource, polymorphic: true

	validates :resource_id, uniqueness: {
		scope: [:basket_id, :resource_type],
		message: "This promo code is already used"
	}, if: :is_promo?

	validate :combining_codes, if: :is_promo_code?

	scope :items,      -> { where(resource_type: 'Item') }
	scope :promotions, -> { where(resource_type: 'Promotion') }

	default_scope { preload(:resource) }

	def is_promo?
		resource_type == 'Promotion'
	end

	def is_promo_code?
		is_promo? and resource.kind != 'product'
	end

	def combining_codes
		if basket.reload.promotions.not_combinable.count > 0
			errors.add :base, 'You already used a code that cannot be used in conjunction with other codes'
		elsif basket.reload.promotions.codes.count > 0 and !resource.can_combine
			errors.add :base, 'This code cannot be used in conjunction with other codes'
		end
	end

	def combine_not_combinable?
		basket.reload.promotions.not_combinable.count > 0 or (basket.reload.promotions.codes.count > 0 and !resource.not_combinable)
	end

	def name
		# if resource_type == 'Item' then resource.name else '' end
		resource.try(:name)
	end

	def price
		resource.try(:price)
	end
end
