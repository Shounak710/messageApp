class AddMessagesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :message, null: true, foreign_key: true
  end
end
