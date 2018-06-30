class AddOrderNoToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :order_no, :string
    add_column :orders, :note, :text
    add_column :orders, :paid_at, :datetime
  end
end
