class AddUrlToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :url, :string
  end
end
