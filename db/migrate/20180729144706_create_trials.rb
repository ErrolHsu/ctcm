class CreateTrials < ActiveRecord::Migration[5.2]
  def change
    create_table :trials do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :address
      t.string :message
      t.string :product_name

      t.timestamps
    end
  end
end
