require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  setup do
    @company = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, company: { city: @company.city, name: @company.name, country: @company.country, is_admin: @company.is_admin, phone_number: @company.phone_number, state: @company.state, street_address: @company.street_address, website: @company.website, zip_code: @company.zip_code }
    end

    assert_redirected_to user_path(assigns(:company))
  end

  test "should show user" do
    get :show, id: @company
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @company
    assert_response :success
  end

  test "should update user" do
    put :update, id: @company, company: { city: @company.city, name: @company.name, country: @company.country, is_admin: @company.is_admin, phone_number: @company.phone_number, state: @company.state, street_address: @company.street_address, website: @company.website, zip_code: @company.zip_code }
    assert_redirected_to user_path(assigns(:company))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @company
    end

    assert_redirected_to users_path
  end
end
