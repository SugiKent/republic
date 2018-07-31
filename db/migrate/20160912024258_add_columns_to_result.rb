class AddColumnsToResult < ActiveRecord::Migration
  def change
    add_column :results, :rep_1, :integer
    add_column :results, :rep_2, :integer
    add_column :results, :rep_3, :integer
    add_column :results, :comment, :text
  end
end
