class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.integer :price
      t.integer :quantity

      t.timestamps
    end
  end
end
