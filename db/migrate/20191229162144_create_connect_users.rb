class CreateConnectUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :connect_users do |t|

      t.timestamps
    end
  end
end
