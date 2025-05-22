require "test_helper"

class Admin::GroupPostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_group_posts_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_group_posts_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_group_posts_destroy_url
    assert_response :success
  end
end
