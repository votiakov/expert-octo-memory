class AddQuantityToBasketItem < ActiveRecord::Migration[5.1]
  def change
  	add_column :basket_items, :quantity, :integer

  	BasketItem.update_all(quantity: 2)
  end
end
