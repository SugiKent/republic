class ChangeDatatypeTitleOfDocuments < ActiveRecord::Migration
  def change
    change_column :documents, :title, :text
    change_column :evaluations, :content, :text
  end
end
