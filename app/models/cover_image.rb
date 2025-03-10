# Cover Image
class CoverImage < ApplicationRecord
  include Scraper

  has_attached_file :image, styles: {thumb: 'x200^'},
    default_url: '/images/CoverUnavailable.png'

  serialize :response_data, JSON

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  TYPES = {
    non_music: 'Books, DVDs (not music)',
    music: 'Music'
  }.with_indifferent_access.freeze

  STATUSES = {
    unprocessed: 'Has not been processed',
    error:       'There was a problem retrieving the cover image.',
    not_found:   'Nothing was found after searching',
    processed:   'Successfully processed, image found.'
  }.with_indifferent_access.freeze

  IDENTIFIERS = %w(upc isbn lccn oclc ht_id issn).freeze

  DEFAULT_BOOKS         = %w(Book-Blue.png Book-Gray.png Book-Orange.png).freeze
  DEFAULT_BOOKS_LEN     = DEFAULT_BOOKS.length.freeze
  DEFAULT_MUSIC         = %w(Music-Blue.png Music-Gray.png Music-Orange.png).freeze
  DEFAULT_MUSIC_LEN     = DEFAULT_MUSIC.length.freeze
  DEFAULT_SCHOLARLY     = %w(Scholar-Blue.png Scholar-Gray.png Scholar-Orange.png).freeze
  DEFAULT_SCHOLARLY_LEN = DEFAULT_SCHOLARLY.length.freeze
  DEFAULT_FILM          = %w(Film-Blue.png Film-Gray.png Film-Orange.png).freeze
  DEFAULT_FILM_LEN     = DEFAULT_FILM.length.freeze

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

  before_save :clean_fields

  attr_accessor :run_lookup
  attr_accessor :search_term

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
      [i, ident.strip]
    end.compact.to_h
  end

  # @Returns default image
  def default_image_path
    Rails.root.join('public', 'images', 'CoverUnavailable.png')
  end

  private

  def assign_defaults
    self.status ||= 'unprocessed'
  end

  def clean_fields
    self.artist_name = artist_name.gsub(/\(Musical group\)/i, '').strip if artist_name
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
