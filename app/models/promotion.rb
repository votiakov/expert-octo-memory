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

	has_many :promotion_items
	has_many :items, through: :promotion_items

	scope :percents, -> { where(kind: :percent) }
	scope :amounts,  -> { where(kind: :amount) }
	scope :products, -> { where(kind: :product) }
end