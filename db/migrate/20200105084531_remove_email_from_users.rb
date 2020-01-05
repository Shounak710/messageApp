class RemoveEmailFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :email
    add_index :users, :name, unique: true
  end
end
