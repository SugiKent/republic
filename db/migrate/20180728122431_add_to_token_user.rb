class AddToTokenUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token, :string, charset: 'utf8', collation: 'utf8_bin'
  end
end
