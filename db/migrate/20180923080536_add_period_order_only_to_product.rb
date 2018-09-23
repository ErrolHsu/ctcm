class AddPeriodOrderOnlyToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column  :products, :period_order_only, :boolean, default: false
  end
end
