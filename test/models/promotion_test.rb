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

require 'test_helper'

class PromotionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
