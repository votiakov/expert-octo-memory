class CreateBaskets < ActiveRecord::Migration[5.1]
	def change
		create_table :baskets do |t|
			t.boolean :checked_out, default: false

			t.timestamps
		end
	end
end
