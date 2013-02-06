require 'test_helper'

class Houston::CobrandGroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:houston_cobrand_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cobrand_group" do
    assert_difference('Houston::CobrandGroup.count') do
      post :create, :cobrand_group => { }
    end

    assert_redirected_to cobrand_group_path(assigns(:cobrand_group))
  end

  test "should show cobrand_group" do
    get :show, :id => houston_cobrand_groups(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => houston_cobrand_groups(:one).to_param
    assert_response :success
  end

  test "should update cobrand_group" do
    put :update, :id => houston_cobrand_groups(:one).to_param, :cobrand_group => { }
    assert_redirected_to cobrand_group_path(assigns(:cobrand_group))
  end

  test "should destroy cobrand_group" do
    assert_difference('Houston::CobrandGroup.count', -1) do
      delete :destroy, :id => houston_cobrand_groups(:one).to_param
    end

    assert_redirected_to houston_cobrand_groups_path
  end
end
