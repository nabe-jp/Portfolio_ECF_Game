require "test_helper"

class Public::Groups::GroupMembershipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_groups_group_memberships_index_url
    assert_response :success
  end
end
