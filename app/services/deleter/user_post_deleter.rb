module Deleter
  class UserPostDeleter
    def initialize(user_post, deleted_by:)
      @user_post = user_post
      @deleted_by = deleted_by
      @now = Time.current
    end

    def call
      @user_post.update!(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)

      soft_delete(@user_post.user_post_comments)
    end

    private

    def soft_delete(records)
      records.update_all(is_deleted: true, deleted_at: @now, deleted_by_id: @deleted_by.id)
    end
  end
end