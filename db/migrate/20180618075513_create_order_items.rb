class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true
      t.string :product_name
      t.integer :price
      t.integer :quantity

      t.timestamps
    end
  end
end
