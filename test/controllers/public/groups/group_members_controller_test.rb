require "test_helper"

class Public::Groups::GroupMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_groups_group_members_index_url
    assert_response :success
  end
end
