class MakeConnStatusNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :users, :connection_status, true
  end
end
