class CreateOrders < ActiveRecord::Migration[5.1]
	def change
		create_table :orders do |t|
			t.references :basket, index: true
			t.references :customer, index: true

			t.string :status

			t.timestamps
		end
	end
end
