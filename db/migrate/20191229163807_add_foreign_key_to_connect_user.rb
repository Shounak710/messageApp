class AddForeignKeyToConnectUser < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :connect_users, :users
  end
end
