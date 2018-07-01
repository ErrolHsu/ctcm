class AddMerchantTradeNoToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :merchant_trade_no, :string
  end
end
