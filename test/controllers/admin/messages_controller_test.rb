require "test_helper"

class Admin::MessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get admin_messages_destroy_url
    assert_response :success
  end
end
