require "test_helper"

class Admin::Groups::GroupMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_groups_group_members_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_groups_group_members_show_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_groups_group_members_destroy_url
    assert_response :success
  end
end
