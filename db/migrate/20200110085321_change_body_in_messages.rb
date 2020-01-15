class ChangeBodyInMessages < ActiveRecord::Migration[6.0]
  def change
    change_column :messages, :body, :text, null: false
  end
end
