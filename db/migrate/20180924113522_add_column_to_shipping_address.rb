class AddColumnToShippingAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :shipping_addresses, :name, :string
    add_column :shipping_addresses, :email, :string
    add_column :shipping_addresses, :phone, :string
  end
end
