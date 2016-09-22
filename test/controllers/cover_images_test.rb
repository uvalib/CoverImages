require 'test_helper'

class CoverImagesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @ci = create(:known_book)
  end


  test "should return image json for json request" do
    get cover_image_url(@ci.doc_id), as: :json
    assert_response :success
    body = JSON.parse @response.body
    assert body['image_base64'].present?
  end


end
