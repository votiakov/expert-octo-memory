# == Schema Information
#
# Table name: promotion_items
#
#  id           :integer          not null, primary key
#  promotion_id :integer
#  item_id      :integer
#  quantity     :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_promotion_items_on_item_id       (item_id)
#  index_promotion_items_on_promotion_id  (promotion_id)
#

class PromotionItem < ApplicationRecord
	belongs_to :item
	belongs_to :promotion
end
