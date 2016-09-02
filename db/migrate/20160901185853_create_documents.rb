class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :cover_images do |t|
      t.string :doc_id, index: true
      t.string :title
      t.attachment :image

      t.timestamps
    end
  end
end
