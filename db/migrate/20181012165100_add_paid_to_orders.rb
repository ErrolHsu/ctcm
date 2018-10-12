class AddPaidToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :paid, :boolean, default: false
    add_column :period_orders, :paid_at, :datetime
  end
end
