require 'test_helper'
class Admin::CoverImagesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @ci = create(:cover_image, [:book, :album].sample, :completed)
  end

  test "should get index" do
    get admin_cover_images_url
    assert_response :success
  end

  test "should get show" do
    get admin_cover_images_url(@ci.id)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_cover_image_url @ci.id
    assert_response :success
  end

  test "should get new" do
    get new_admin_cover_image_url
    assert_response :success

  end

  test "should get destroy" do
    delete admin_cover_image_url @ci
    assert_response :redirect
    assert flash[:success].present?
  end

end
