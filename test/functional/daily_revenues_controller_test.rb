require 'test_helper'

class DailyRevenuesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:daily_revenues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create daily_revenue" do
    assert_difference('DailyRevenue.count') do
      post :create, :daily_revenue => { }
    end

    assert_redirected_to daily_revenue_path(assigns(:daily_revenue))
  end

  test "should show daily_revenue" do
    get :show, :id => daily_revenues(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => daily_revenues(:one).to_param
    assert_response :success
  end

  test "should update daily_revenue" do
    put :update, :id => daily_revenues(:one).to_param, :daily_revenue => { }
    assert_redirected_to daily_revenue_path(assigns(:daily_revenue))
  end

  test "should destroy daily_revenue" do
    assert_difference('DailyRevenue.count', -1) do
      delete :destroy, :id => daily_revenues(:one).to_param
    end

    assert_redirected_to daily_revenues_path
  end
end
