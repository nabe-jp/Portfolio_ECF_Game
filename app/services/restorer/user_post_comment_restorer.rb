module Restorer
  class UserPostCommentRestorer
    def initialize(comment, restored_due_to_parent: false)
      @comment = comment
      @restored_due_to_parent = restored_due_to_parent
    end

    def call
      ActiveRecord::Base.transaction do
        restore_params = {is_deleted: false, deleted_at: nil, deleted_by_id: nil, deleted_reason: nil,
          deleted_due_to_parent: false}

        # 親の連鎖削除で削除されたものを復元
        if @restored_due_to_parent && @comment.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 個別の復元
        elsif !@restored_due_to_parent && !@comment.deleted_due_to_parent
          restore_params[:is_public] = false
        
        # 想定していないアクセス
        else
          raise "#{self.class.name}で想定外のアクセスです"
        end
        
        @comment.update!(restore_params)
      end
    end
  end
end