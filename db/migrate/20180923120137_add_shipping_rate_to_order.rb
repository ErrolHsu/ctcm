class AddShippingRateToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :shipping_rate, :integer
    add_column :orders, :payment, :string
    rename_column :orders, :regular, :period
  end
end
