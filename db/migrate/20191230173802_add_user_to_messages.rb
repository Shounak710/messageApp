class AddUserToMessages < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :messages, :user
  end
end
