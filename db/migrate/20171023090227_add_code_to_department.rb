class AddCodeToDepartment < ActiveRecord::Migration
  def change
    add_column :departments, :code, :string
  end
end
