class CreateTradeInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :trade_infos do |t|
      t.references :order, foreign_key: true
      t.integer :rtn_code
      t.string :merchant_trade_no
      t.string :trade_no
      t.integer :trade_amt
      t.integer :amount
      t.string :rtn_msg
      t.jsonb :total_info

      t.timestamps
    end
  end
end
