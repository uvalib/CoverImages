class AddKeyTypesToCoverImages < ActiveRecord::Migration[5.0]
  def change

    add_column :cover_images, :isbn, :string, index: true
    add_column :cover_images, :oclc, :string, index: true
    add_column :cover_images, :lccn, :string, index: true
    add_column :cover_images, :upc, :string, index: true

    add_column :cover_images, :mbid, :string, index: true

    add_column :cover_images, :artist_name, :string
    add_column :cover_images, :album_name, :string


    # not key related
    add_column :cover_images, :status, :string
    add_column :cover_images, :doc_type, :string
  end
end
