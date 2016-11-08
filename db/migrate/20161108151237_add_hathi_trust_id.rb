class AddHathiTrustId < ActiveRecord::Migration[5.0]
  def change
    add_column :cover_images, :ht_id, :string
  end
end
