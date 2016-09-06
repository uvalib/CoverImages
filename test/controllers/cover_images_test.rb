require 'test_helper'

class CoverImagesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @ci = create(:cover_image)
  end


  test "should return image json" do
    get cover_image_url(@ci.doc_id)
    assert_response :success
    body = JSON.parse @response.body
    assert body['image_base64'].present?
  end


end
