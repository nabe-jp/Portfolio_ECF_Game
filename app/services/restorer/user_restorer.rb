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
        restore(@user.group_post_comments)

        restore(@user.group_memberships)

        @user.owned_groups.each do |group|
          Restorer::GroupRestorer.call(group)
        end

        @user.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
      end
    end

    private

    def restore(records)
      records.update_all(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    end
  end
end