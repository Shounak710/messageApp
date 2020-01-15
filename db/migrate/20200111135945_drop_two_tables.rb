class DropTwoTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :connect_users
    drop_table :api_users
  end
end
