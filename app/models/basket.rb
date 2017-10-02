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
end
