class AddResponseDataToCoverImages < ActiveRecord::Migration[5.0]
  def change
    add_column :cover_images, :response_data, :json
  end
end
