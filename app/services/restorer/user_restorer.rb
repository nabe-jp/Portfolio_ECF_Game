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
        # 復元をするために一時的にアクティブにする
        @user.update!(user_status: :active, deleted_at: nil, deleted_by_id: nil, deleted_reason: nil)

        # 子要素の連鎖復元
        @user.user_posts.each do |post|
          Restorer::UserPostRestorer.new(post, restored_via_parent: true).call
        end

        # ユーザー本人のコメント削除
        @user.user_post_comments.find_each do |comment|
          Restorer::UserPostCommentRestorer.new(comment, restored_via_parent: true).call
        end

        @user.owned_groups.each do |group|
          Restorer::GroupRestorer.new(group, restored_via_parent: true).call
        end

        @memberships.each do |membership|
          Restorer::GroupMemberRestorer.new(membership, restored_via_parent: true).call
        end

        # 復元が終わったので非公開状態に更新
        @user.update!(user_status: :restored_pending)
      end
    end
  end
end