module Restorer
  class UserRestorer
    def self.call(user)
      new(user).call
    end

    def initialize(user)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        restore(@user.user_posts)
        restore(@user.user_post_comments)

        restore(@user.group_posts)

        # 投稿にぶら下がったコメントは、1対多なので配列処理(userと直接アソシエーションが繋がっていない)
        group_post_comments = @user.group_posts.flat_map(&:group_post_comments)
        restore_each(group_post_comments)

        restore_without_is_public(@user.group_memberships)

        @user.owned_groups.each do |group|
          Restorer::GroupRestorer.new(group).call
        end

        @user.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
      end
    end

    private

    def restore(records)
      records.update_all(is_deleted: false, deleted_at: nil, deleted_by_id: nil, is_public: false)
    end

    def restore_each(records)
      Array(records).each do |record|
        record.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil, is_public: false)
      end
    end

    def restore_without_is_public(records)
      records.update_all(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    end
  end
end