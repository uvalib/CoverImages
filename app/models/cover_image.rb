class CoverImage < ApplicationRecord
  include Scraper

  has_attached_file :image, styles: {thumb: 'x150^', medium: 'x400^'},
    default_url: 'default_bookcover.gif'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  TYPES = {'non_music': 'Books, DVDs (not music)', 'music': 'Music'}.freeze
  STATUSES = {
    'unprocessed': 'Has not been processed',
    'error': 'There was a problem retrieving the cover image.',
    'not_found': 'Nothing was found after searching',
    'processed': 'Successfully processed, image found.'
  }.freeze
  IDENTIFIERS = %w(upc isbn lccn oclc).freeze

  validates_presence_of :doc_id
  validates_uniqueness_of :doc_id
  validates_inclusion_of :doc_type, in: TYPES.keys.map(&:to_s),
    message: "Must be either #{TYPES.keys.to_sentence(
      last_word_connector: ' or ',
      two_words_connector: ' or ')}"
  validates_inclusion_of :status, in: STATUSES.keys.map(&:to_s)
  validate :required_identifiers, if: "non_music?"
  validates_presence_of :artist_name, :album_name, if: "music?"

  after_initialize :assign_defaults

  after_create :lookup


  def music?
    doc_type == 'music'
  end
  def non_music?
    doc_type == 'non-music'
  end


  ## returns [Hash] Present id type mapped to value
  #
  def present_ids
    IDENTIFIERS.map do |i|
      ident = self.send(i)
      next unless ident.present?
      [i, ident]
    end.compact.to_h
  end

  private
  def assign_defaults
    self.status ||= STATUSES['unprocessed']
  end

  # for non-music validation
  def required_identifiers
    present = IDENTIFIERS.any? do |ident|
      self.send(ident).present?
    end
    unless present?
      self.errors.add(:base, "one of #{IDENTIFIERS.
        to_sentence(last_word_connector: ' or ')} is required.")
    end
  end


end
