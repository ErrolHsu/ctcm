class CreateShippingAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :shipping_addresses do |t|
      t.references :order, foreign_key: true
      t.string :address

      t.timestamps
    end
  end
end
