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

        # 投稿にぶら下がったコメントは、1対多なので配列処理(userと直接アソシエーションが繋がっていない)
        group_post_comments = @user.group_posts.flat_map(&:group_post_comments)
        soft_delete_each(group_post_comments)

        soft_delete(@user.group_memberships)

        # 所有していたグループ
        @user.owned_groups.each do |group|
          Deleter::GroupDeleter.new(group, deleted_by: @deleted_by).call
        end

        # 最後にユーザー自身を論理削除
        @user.update!(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
      end
    end

    private

    def soft_delete(records)
      records.update_all(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
    end

    def soft_delete_each(records)
      Array(records).each do |record|
        record.update!(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
      end
    end
  end
end