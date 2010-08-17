require 'test_helper'

class PairsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pairs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pair" do
    assert_difference('Pair.count') do
      post :create, :pair => { }
    end

    assert_redirected_to pair_path(assigns(:pair))
  end

  test "should show pair" do
    get :show, :id => pairs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pairs(:one).to_param
    assert_response :success
  end

  test "should update pair" do
    put :update, :id => pairs(:one).to_param, :pair => { }
    assert_redirected_to pair_path(assigns(:pair))
  end

  test "should destroy pair" do
    assert_difference('Pair.count', -1) do
      delete :destroy, :id => pairs(:one).to_param
    end

    assert_redirected_to pairs_path
  end
end
