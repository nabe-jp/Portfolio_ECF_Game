module Restorer
  class UserPostRestorer
    def initialize(user_post)
      @user_post = user_post
    end

    def call
      @user_post.update!(is_deleted: false, deleted_at: nil, deleted_by_id: nil)

      restore(@user_post.user_post_comments)
    end

    private

    def restore(records)
      records.update_all(is_deleted: false, deleted_at: nil, deleted_by_id: nil)
    end
  end
end