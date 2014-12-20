require 'test_helper'

class AssociatedMediaControllerTest < ActionController::TestCase
  test "should get pictures" do
    get :pictures
    assert_response :success
  end

  test "should get videos" do
    get :videos
    assert_response :success
  end

  test "should get documents" do
    get :documents
    assert_response :success
  end

end
