class AddCurrentToPeriodOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :period_orders, :current, :boolean, default: false
  end
end
