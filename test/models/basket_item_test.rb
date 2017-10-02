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
#
# Indexes
#
#  index_basket_items_on_basket_id                      (basket_id)
#  index_basket_items_on_resource_type_and_resource_id  (resource_type,resource_id)
#

require 'test_helper'

class BasketItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
