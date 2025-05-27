module Deleter
  class UserDeleter
    def self.call(user, deleted_by:)
      new(user, deleted_by).call
    end

    def initialize(user, deleted_by)
      @user = user
      @deleted_by = deleted_by
      @now = Time.current
    end

    def call
      ActiveRecord::Base.transaction do
        soft_delete(@user.user_posts)
        soft_delete(@user.user_post_comments)

        soft_delete(@user.group_posts)
        soft_delete(@user.group_post_comments)

        soft_delete(@user.group_memberships)

        # 所有していたグループ
        @user.owned_groups.each do |group|
          Deleter::GroupDeleter.call(group, deleted_by: @deleted_by)
        end

        # 最後にユーザー自身を論理削除
        @user.update!(
          is_deleted: true,
          deleted_at: @now,
          deleted_by_id: @deleted_by.id
        )
      end
    end

    private

    def soft_delete(records)
      records.update_all(
        is_deleted: true,
        deleted_at: @now,
        deleted_by_id: @deleted_by.id
      )
    end
  end
end