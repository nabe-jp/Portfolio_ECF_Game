module Deleter
  class UserDeleter
    # このオブジェクトの削除理由の固定
    APPLIED_DELETION_REASON = :parent_user_deleted

    def initialize(user, deleted_by:, deleted_reason:)
      @user = user
      @deleted_by = deleted_by
      @deleted_reason = deleted_reason
    end

    def call
      now = Time.current

      # 途中で失敗したら全体をロールバック
      ActiveRecord::Base.transaction do
        # ユーザー本人の投稿削除
        @user.user_posts.find_each do |post|
          Deleter::UserPostDeleter.new(post, deleted_by: @deleted_by,
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end

        # ユーザー本人のコメント削除
        @user.user_post_comments.find_each do |comment|
          Deleter::UserPostCmmentDeleter.new(comment, deleted_by: @deleted_by,
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end

        # 所有グループの削除(内部で再帰的処理)
        @user.owned_groups.find_each do |group|
          Deleter::GroupDeleter.new(group, deleted_by: @deleted_by,
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end

        # 所属グループメンバーシップをまとめて削除(内部で関連イベント・通知・投稿も削除)
        @user.group_memberships.find_each do |membership|
          Deleter::GroupMemberDeleter.new(membership, deleted_by: @deleted_by,
            deleted_reason: APPLIED_DELETION_REASON, deleted_via_parent: true).call
        end

        # ユーザー自身の論理削除
        @user.update!(user_status: :deactivated, 
          deleted_at: now, deleted_by_id: @deleted_by.id, deleted_reason: @deleted_reason)
      end
    end
  end
end