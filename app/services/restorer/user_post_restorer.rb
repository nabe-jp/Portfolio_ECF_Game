module Restorer
  class UserPostRestorer
    def initialize(user_post, restored_due_to_parent: false)
      @user_post = user_post
      @restored_due_to_parent = restored_due_to_parent
    end

    def call
      ActiveRecord::Base.transaction do
        restore_params = {is_deleted: false, deleted_at: nil, deleted_by_id: nil, deleted_reason: nil,
          deleted_due_to_parent: false}

        # 親の連鎖削除で削除されたものを復元
        if @restored_due_to_parent && @user_post.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 個別の復元
        elsif !@restored_due_to_parent && !@user_post.deleted_due_to_parent
          restore_params[:is_public] = false

        # 想定していないアクセス
        else
          raise "#{self.class.name}で想定外のアクセスです"
        end

        @user_post.update!(restore_params)

        # 子要素の連鎖復元
        @user_post.user_post_comments.each do |comment|
          Restorer::UserPostCommentRestorer.new(comment, restored_due_to_parent: true).call
        end
      end
    end
  end
end