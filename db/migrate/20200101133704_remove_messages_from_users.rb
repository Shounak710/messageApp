class RemoveMessagesFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_reference :users, :message, foreign_key: true
  end
end
