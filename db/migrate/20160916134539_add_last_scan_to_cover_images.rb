class AddLastScanToCoverImages < ActiveRecord::Migration[5.0]
  def change
    add_column :cover_images, :last_search, :datetime
  end
end
