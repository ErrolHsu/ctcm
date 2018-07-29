class AddExecutedToTrial < ActiveRecord::Migration[5.2]
  def change
    add_column :trials, :executed, :boolean, default: false
  end
end
