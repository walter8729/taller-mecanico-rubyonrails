require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in_as_admin
    get root_path
    assert_response :success
  end
end
