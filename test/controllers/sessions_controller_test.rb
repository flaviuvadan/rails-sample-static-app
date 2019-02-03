require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should perform get" do
    get login_path
    assert_response :success
  end

  test "should perform create" do
    post login_path
    assert_response :success
  end

  test "should perform delete" do
    delete logout_path
    assert_response :success
  end

end
