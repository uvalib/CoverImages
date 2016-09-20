FactoryGirl.define do
  factory :cover_image do
    doc_id    Faker::Code.asin

    doc_type  CoverImage::TYPES.keys.first
    status    CoverImage::STATUSES.keys.first

    trait :book do
      title     Faker::Book.title
      isbn      Faker::Code.isbn
    end

    trait :album do
      artist_name Faker::Superhero.name
      album_name  Faker::Book.title
    end

    trait :completed do
      status  CoverImage::STATUSES.keys.last
      image   Faker::Avatar.image
    end

    factory :known_book do
      doc_id  'u2243358'
      title   'The giver'
      isbn    '0395645662'

    end

  end
end
