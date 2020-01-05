class AddUserIdToConnectUser < ActiveRecord::Migration[6.0]
  def change
    add_column :connect_users, :user_id, :integer
  end
end
