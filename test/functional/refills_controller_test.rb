require 'test_helper'

class RefillsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:refills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create refill" do
    assert_difference('Refill.count') do
      post :create, :refill => { }
    end

    assert_redirected_to refill_path(assigns(:refill))
  end

  test "should show refill" do
    get :show, :id => refills(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => refills(:one).to_param
    assert_response :success
  end

  test "should update refill" do
    put :update, :id => refills(:one).to_param, :refill => { }
    assert_redirected_to refill_path(assigns(:refill))
  end

  test "should destroy refill" do
    assert_difference('Refill.count', -1) do
      delete :destroy, :id => refills(:one).to_param
    end

    assert_redirected_to refills_path
  end
end
