class MakeConnStatusNotNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :connection_status, false
  end
end
