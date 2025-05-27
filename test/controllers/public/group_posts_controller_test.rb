require "test_helper"

class Public::GroupPostsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_group_posts_new_url
    assert_response :success
  end

  test "should get create" do
    get public_group_posts_create_url
    assert_response :success
  end

  test "should get show" do
    get public_group_posts_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_group_posts_edit_url
    assert_response :success
  end

  test "should get update" do
    get public_group_posts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get public_group_posts_destroy_url
    assert_response :success
  end
end
