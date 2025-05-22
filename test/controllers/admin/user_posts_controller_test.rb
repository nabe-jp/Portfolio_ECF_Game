require "test_helper"

class Admin::UserPostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_user_posts_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_user_posts_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_user_posts_destroy_url
    assert_response :success
  end
end
