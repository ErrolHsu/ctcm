class CreatePeriodOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :period_orders do |t|
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :no
      t.integer :amount
      t.date :expected_date
      t.string :status
      t.boolean :paid
      t.string :shipping_status

      t.timestamps
    end
  end
end
