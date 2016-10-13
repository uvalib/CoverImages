require 'test_helper'
class Admin::CoverImagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @ci = create(:cover_image, [:book, :album].sample, :completed)
  end

  def login
    sign_in FactoryGirl.create(:admin)
  end

  test "should get index" do
    login
    get admin_cover_images_url
    assert_response :success
  end

  test "should get show" do
    login
    get admin_cover_images_url(@ci.id)
    assert_response :success
  end

  test "should get edit" do
    login
    get edit_admin_cover_image_url @ci.id
    assert_response :success
  end

  test "should get new" do
    login
    get new_admin_cover_image_url
    assert_response :success
  end

  test "should get destroy" do
    login
    delete admin_cover_image_url @ci
    assert_response :redirect
    assert flash[:success].present?
  end

  test "should block unauthenticated" do
    get admin_cover_images_url
    assert_response :redirect
  end

end
