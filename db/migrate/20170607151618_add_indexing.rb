class AddIndexing < ActiveRecord::Migration[5.0]
  def change
    add_index :cover_images, :title
    add_index :cover_images, :artist_name
    add_index :cover_images, :album_name
    add_index :cover_images, :created_at
    add_index :cover_images, :id
  end
end
