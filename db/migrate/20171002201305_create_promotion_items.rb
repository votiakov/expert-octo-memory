class CreatePromotionItems < ActiveRecord::Migration[5.1]
	def change
		create_table :promotion_items do |t|
			t.references :promotion, index: true
			t.references :item, index: true

			t.integer :quantity, default: 1

			t.timestamps
		end
	end
end
