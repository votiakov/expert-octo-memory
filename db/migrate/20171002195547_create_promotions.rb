class CreatePromotions < ActiveRecord::Migration[5.1]
	def change
		create_table :promotions do |t|
			t.string :kind, null: false

			t.float :value
			t.string :code

			t.boolean :can_combine, default: false

			t.integer :quantity

			t.timestamps
		end
	end
end
