# Cover Image
class CoverImage < ApplicationRecord
  include Scraper

  has_attached_file :image, styles: {thumb: 'x200^', medium: 'x500^'},
    default_url: 'default_bookcover.gif'

  serialize :response_data, JSON

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  TYPES = {
    non_music: 'Books, DVDs (not music)', music: 'Music'
  }.with_indifferent_access.freeze
  STATUSES = {
    unprocessed: 'Has not been processed',
    error:       'There was a problem retrieving the cover image.',
    not_found:   'Nothing was found after searching',
    processed:   'Successfully processed, image found.'
  }.with_indifferent_access.freeze
  IDENTIFIERS = %w(upc isbn lccn oclc ht_id).freeze

  validates :doc_id, presence: true, uniqueness: true

  validates :doc_type, inclusion: {
    in:      TYPES.keys.map(&:to_s),
    message: "Must be either #{TYPES.keys.to_sentence(
      last_word_connector: ' or ',
      two_words_connector: ' or ')}"
  }
  validates :status, inclusion: {in: STATUSES.keys.map(&:to_s)}
  validate :required_identifiers, if: "non_music?"
  validates :artist_name, :album_name, presence: true, if: "music?"

  after_initialize :assign_defaults

  after_commit :lookup, if: ->(ci) {ci.run_lookup}

  attr_accessor :run_lookup
  attr_accessor :search_term

  scope :search, ->(search_term) {
    where(
      'doc_id LIKE :search OR '\
      'title LIKE :search OR artist_name LIKE :search OR '\
      'album_name LIKE :search', search: "%#{search_term}%"
    )
  }

  def music?
    doc_type == 'music'
  end

  def non_music?
    doc_type == 'non_music'
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
    self.status ||= 'unprocessed'
  end

  # for non-music validation
  def required_identifiers
    present =
      IDENTIFIERS.any? do |ident|
        self.send(ident).present?
      end
    return if present
    self.errors.add(
      :base, "One of #{IDENTIFIERS.to_sentence(
        last_word_connector: ' or ')} is required.")
  end
end
