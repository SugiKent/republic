class AddImageToFeature < ActiveRecord::Migration
  def change
    add_column :features, :image, :string
  end
end
