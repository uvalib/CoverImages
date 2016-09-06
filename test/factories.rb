FactoryGirl.define do
  factory :cover_image do
    doc_id 'abc'
    title 'test'
    doc_type CoverImage::TYPES.first
    status CoverImage::STATUSES.first
  end
end
