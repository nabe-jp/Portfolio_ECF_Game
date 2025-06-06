module Deleter
  class UserDeleter
    def self.call(user, deleted_by:, deleted_reason:)
      new(user, deleted_by: deleted_by, deleted_reason: deleted_reason).call
    end

    def initialize(user, deleted_by:, deleted_reason:)
      @user = user
      @deleted_by = deleted_by
      @deleted_reason = deleted_reason
      @parent_deletion_reason = :parent_user_deleted
    end

    def call
      now = Time.current
      ActiveRecord::Base.transaction do
        # ユーザー本人の投稿削除
        @user.user_posts.find_each do |post|
          Deleter::UserPostDeleter.call(post, deleted_by: @deleted_by, deleted_reason: @deleted_reason)
        end

        # 所属グループメンバーシップをまとめて削除(内部で関連イベント・通知・投稿も削除)
        @user.group_memberships.find_each do |membership|
          Deleter::GroupMemberDeleter.call(membership, 
            deleted_by: @deleted_by, deleted_reason: @parent_deletion_reason)
        end

        # 所有グループの削除(内部で再帰的処理)
        @user.owned_groups.find_each do |group|
          Deleter::GroupDeleter.new(group, 
            deleted_by: @deleted_by, deleted_reason: @parent_deletion_reason).call
        end

        # ユーザー自身の論理削除
        @user.update!(is_deleted: true, 
          deleted_at: now, deleted_by_id: @deleted_by.id, deleted_reason: @deleted_reason)
      end
    end
  end
end