# == Schema Information
#
# Table name: orders
#
#  id          :integer          not null, primary key
#  basket_id   :integer
#  customer_id :integer
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_orders_on_basket_id    (basket_id)
#  index_orders_on_customer_id  (customer_id)
#

class Order < ApplicationRecord
	belongs_to :customer, inverse_of: :orders
	belongs_to :basket

	accepts_nested_attributes_for :customer
end
