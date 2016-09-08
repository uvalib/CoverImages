class AddLastFmUrlToCoverImages < ActiveRecord::Migration[5.0]
  def change
    add_column :cover_images, :last_fm_url, :string
  end
end
