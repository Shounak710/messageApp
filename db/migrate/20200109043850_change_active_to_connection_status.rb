class ChangeActiveToConnectionStatus < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :active, :connection_status
  end
end
