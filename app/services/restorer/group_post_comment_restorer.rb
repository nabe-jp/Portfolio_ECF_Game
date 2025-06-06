module Restorer
  class GroupPostCommentRestorer
    def initialize(comment, restored_via_parent: false)
      @comment = comment
      @restored_via_parent = restored_via_parent
    end

    def call
      ActiveRecord::Base.transaction do
        restore_params = {is_deleted: false, deleted_at: nil, deleted_by_id: nil, deleted_reason: nil,
          deleted_due_to_parent: false}

        if @comment.group_post.is_deleted
          raise "#{self.class.name}にて親が削除されているため復元エラーが発生しました"
        
        # 親の連鎖削除で削除されたものを復元
        elsif @restored_via_parent && @comment.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 個別の復元
        elsif !@restored_via_parent && !@comment.deleted_due_to_parent
          restore_params[:is_public] = false
        
        # 想定していないエラー
        else
          raise "#{self.class.name}で想定外のエラーが発生しました"
        end
        
        @comment.update!(restore_params)
      end
    end
  end
end