class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.integer :total
      t.string :type
      t.string :status
      t.string :payment_status
      t.string :shipping_status
      t.integer :period_amount
      t.string :period_type
      t.integer :frequency
      t.integer :exec_times

      t.timestamps
    end
  end
end
