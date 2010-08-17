require 'test_helper'

class SizesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sizes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create size" do
    assert_difference('Size.count') do
      post :create, :size => { }
    end

    assert_redirected_to size_path(assigns(:size))
  end

  test "should show size" do
    get :show, :id => sizes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sizes(:one).to_param
    assert_response :success
  end

  test "should update size" do
    put :update, :id => sizes(:one).to_param, :size => { }
    assert_redirected_to size_path(assigns(:size))
  end

  test "should destroy size" do
    assert_difference('Size.count', -1) do
      delete :destroy, :id => sizes(:one).to_param
    end

    assert_redirected_to sizes_path
  end
end
