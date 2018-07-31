class AddColumnToChatRoom < ActiveRecord::Migration
  def change
    add_reference :chat_rooms, :faculty, index: true, foreign_key: true
  end
end
