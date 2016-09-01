class Document < ApplicationRecord

  has_attached_file :image, styles: {thumb: 'x150>', medium: 'x400>'}

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates_presence_of :name, :image

end
