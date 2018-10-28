class AddTrackingNoToPeriodOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :period_orders, :tracking_no, :string
  end
end
