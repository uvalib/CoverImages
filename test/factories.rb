FactoryGirl.define do
  factory :cover_image do
    doc_id    Faker::Code.asin

    doc_type  CoverImage::TYPES.keys.sample
    status    CoverImage::STATUSES.keys.first

    trait :book do
      doc_type  CoverImage::TYPES.keys.first
      title     Faker::Book.title
      isbn      Faker::Code.isbn
    end

    trait :album do
      doc_type  CoverImage::TYPES.keys.last
      artist_name Faker::Superhero.name
      album_name  Faker::Book.title
    end

    trait :completed do
      status  CoverImage::STATUSES.keys.last
      image   { File.new("#{Rails.root}/test/fixtures/default_bookcover.gif") }
    end

    factory :known_book do
      book
      doc_id  'u2243358'
      title   'The giver'
      isbn    '0395645662 1234'
    end

    factory :known_hathi_trust do
      book
      title 'Thomas Jefferson'
      isbn  nil
      ht_id 'loc.ark:/13960/t4wh30v9t'
    end

    factory :known_album do
      album
      doc_id        'u2733845'
      album_name    'Under The Table and Dreaming'
      artist_name   'Dave Matthews Band'
    end

  end

  factory :admin, class: User do
    email 'test@example.com'
    password 'password'
  end
end
