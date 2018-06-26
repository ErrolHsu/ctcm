class CreateProductVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :product_variants do |t|
      t.references :product, foreign_key: true
      t.string :weight
      t.integer :price
      t.integer :quantity

      t.timestamps
    end
  end
end
