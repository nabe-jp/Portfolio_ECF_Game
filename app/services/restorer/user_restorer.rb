module Restorer
  class UserRestorer
    def initialize(user)
      @user = user
      @memberships = @user.group_memberships - @user.owned_groups.flat_map do |group|
        group.group_memberships.where(user_id: @user.id).to_a
      end
    end

    def call
      ActiveRecord::Base.transaction do
        # Userは直接復元扱い(deleted_due_to_parentではないためhidden_on_parent_restoreは使わない)
        @user.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil, 
          deleted_reason: nil, hidden_by_parent: true)

        # 子要素の連鎖復元
        @user.user_posts.each do |post|
          Restorer::UserPostRestorer.new(post, restored_via_parent: true).call
        end

        @user.owned_groups.each do |group|
          Restorer::GroupRestorer.new(group, restored_via_parent: true).call
        end

        @memberships.each do |membership|
          Restorer::GroupMemberRestorer.new(membership, restored_via_parent: true).call
        end
      end
    end
  end
end