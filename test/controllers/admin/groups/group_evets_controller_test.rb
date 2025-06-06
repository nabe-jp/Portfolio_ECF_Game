require "test_helper"

class Admin::Groups::GroupEvetsControllerTest < ActionDispatch::IntegrationTest
  test "should get admin/groups/group_notices" do
    get admin_groups_group_evets_admin/groups/group_notices_url
    assert_response :success
  end
end
