class CoverImage < ApplicationRecord

  has_attached_file :image, styles: {thumb: 'x150>', medium: 'x400>'},
    default_url: "default_bookcover.gif"

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  TYPES = ['non-music', 'music'].freeze
  STATUSES = ['unprocessed', 'error', 'processed'].freeze

  validates_presence_of :doc_id
  validates_inclusion_of :doc_type, in: TYPES
  validates_inclusion_of :status, in: STATUSES

end
