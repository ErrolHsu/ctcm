class ChangeCartColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :cart_items, :product_variant_id, :integer
    add_column :carts, :token, :string
    add_index :carts, :token
  end
end
