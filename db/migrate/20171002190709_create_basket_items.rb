class CreateBasketItems < ActiveRecord::Migration[5.1]
	def change
		create_table :basket_items do |t|
			t.references :item
			t.references :basket

			t.timestamps
		end
	end
end
