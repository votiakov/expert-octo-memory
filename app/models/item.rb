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

class Item < ApplicationRecord
	has_many :basket_items, as: :resource
	has_many :baskets, through: :basket_items
	# has_many :basket_items
	# has_many :baskets, through: :basket_items

	# scope :products,   -> { where(type: 'Product') }
	# scope :promotions, -> { where(type: 'Promotion') }
end
