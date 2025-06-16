require "test_helper"

class Admin::Groups::GroupPostCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_groups_group_post_comments_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_groups_group_post_comments_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_groups_group_post_comments_destroy_url
    assert_response :success
  end
end
