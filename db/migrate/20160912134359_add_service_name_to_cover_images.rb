class AddServiceNameToCoverImages < ActiveRecord::Migration[5.0]
  def change
    add_column :cover_images, :service_name, :string
  end
end
