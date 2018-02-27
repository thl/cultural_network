require 'test_helper'

class CaptionsControllerTest < ActionController::TestCase
  setup do
    @caption = captions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:captions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create caption" do
    assert_difference('Caption.count') do
      post :create, :caption => { :author_id => @caption.author_id, :content => @caption.content, :feature_id => @caption.feature_id, :language_id => @caption.language_id }
    end

    assert_redirected_to caption_path(assigns(:caption))
  end

  test "should show caption" do
    get :show, :id => @caption
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @caption
    assert_response :success
  end

  test "should update caption" do
    put :update, :id => @caption, :caption => { :author_id => @caption.author_id, :content => @caption.content, :feature_id => @caption.feature_id, :language_id => @caption.language_id }
    assert_redirected_to caption_path(assigns(:caption))
  end

  test "should destroy caption" do
    assert_difference('Caption.count', -1) do
      delete :destroy, :id => @caption
    end

    assert_redirected_to captions_path
  end
end
