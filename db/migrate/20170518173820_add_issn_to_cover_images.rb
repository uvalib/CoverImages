class AddIssnToCoverImages < ActiveRecord::Migration[5.0]
  def change
    add_column :cover_images, :issn, :string
  end
end
