require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should perform get" do
    get login_path
    assert_response :success
  end
end
