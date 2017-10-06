# == Schema Information
#
# Table name: promotions
#
#  id          :integer          not null, primary key
#  kind        :string           not null
#  value       :float
#  code        :string
#  can_combine :boolean          default(FALSE)
#  quantity    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Promotion < ApplicationRecord
	KINDS = [:percent, :amount, :product]

	# has_many :promotion_items
	# has_many :items, through: :promotion_items
	has_one :promotion_item
	has_one :item, through: :promotion_item

	scope :percents, -> { where(kind: :percent) }
	scope :amounts,  -> { where(kind: :amount) }
	scope :products, -> { where(kind: :product) }

	scope :codes, -> { where.not(kind: :product) }

	scope :not_combinable, -> { codes.where(can_combine: false) }

	def price
		item.try(:price)
	end

	def full_info
		'Buy ' + quantity.to_s + ' ' +  item.name + ' for £' + value.to_s
	end
end
