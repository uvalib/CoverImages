FactoryGirl.define do
  factory :cover_image do
    doc_id 'abc'
    title 'test'
    doc_type CoverImage::TYPES.keys.first
    status CoverImage::STATUSES.keys.first

  end
end
