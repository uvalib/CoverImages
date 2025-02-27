class EnlargeStringTypes < ActiveRecord::Migration[5.1]
  def up
    # convert most varchar(255) to varchar (2048)
    # doc_id, image_content_type, mbid, status, doc_type, service_name, and ht_id were excluded
    remove_index :cover_images, :title # 2048 is over the index limit
    change_column :cover_images, :title,           :string, :limit => 2048
    change_column :cover_images, :image_file_name, :string, :limit => 2048
    change_column :cover_images, :isbn,            :string, :limit => 2048
    change_column :cover_images, :oclc,            :string, :limit => 2048
    change_column :cover_images, :lccn,            :string, :limit => 2048
    change_column :cover_images, :upc,             :string, :limit => 2048
    change_column :cover_images, :issn,            :string, :limit => 2048

    add_index :cover_images, :title, length: 255
  end
end