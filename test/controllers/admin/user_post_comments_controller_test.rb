require "test_helper"

class Admin::UserPostCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get admin_user_post_comments_destroy_url
    assert_response :success
  end
end
