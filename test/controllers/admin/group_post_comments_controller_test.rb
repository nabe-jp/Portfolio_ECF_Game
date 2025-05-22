require "test_helper"

class Admin::GroupPostCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get admin_group_post_comments_destroy_url
    assert_response :success
  end
end
