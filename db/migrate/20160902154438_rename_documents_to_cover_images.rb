class RenameDocumentsToCoverImages < ActiveRecord::Migration[5.0]
  def change
    rename_table :documents, :cover_images
  end
end
