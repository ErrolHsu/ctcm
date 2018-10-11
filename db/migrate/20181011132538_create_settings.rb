class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_settings do |t|
      t.references :admin, foreign_key: true
      t.boolean :order_paid_mail, default: true
      t.boolean :order_cancel_mail, default: true

      t.timestamps
    end
  end
end
