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
        
        # 連鎖復元対象外(復元しない)
        if @restored_via_parent && !@comment.deleted_due_to_parent
          Rails.logger.info("#{self.class.name}: 
            連鎖復元対象外のグループ内投稿コメントの復元をスキップしました (id: #{@comment.id})")
          return

        # 親の連鎖削除で削除されたものを復元
        elsif @restored_via_parent && @comment.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 個別の復元
        elsif !@restored_via_parent && !@comment.deleted_due_to_parent
          # 親の状態を確認、親がアクティブな場合、復元を行う
          if !@comment.member.member_status_active? || @comment.group_post.is_deleted
            raise 'コメントを行ったユーザーまたは投稿が削除されているため復元出来ませんでした'
          end

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