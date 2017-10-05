class AddTotalToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :total, :decimal, precision: 8, scale: 2
  end
end
