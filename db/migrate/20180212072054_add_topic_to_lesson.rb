class AddTopicToLesson < ActiveRecord::Migration
  def change
    add_reference :lessons, :topic, index: true, foreign_key: true
    add_column :lessons, :tag, :integer, index: true
  end
end
