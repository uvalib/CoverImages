class AddLockedToCoverImages < ActiveRecord::Migration[5.0]
  def change
    add_column :cover_images, :locked, :boolean, default: false
  end
end
