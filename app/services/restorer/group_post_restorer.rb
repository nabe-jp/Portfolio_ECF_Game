module Restorer
  class GroupPostRestorer
    def initialize(group_post, restored_via_parent: false)
      @group_post = group_post
      @restored_via_parent = restored_via_parent
    end

    def call
      ActiveRecord::Base.transaction do
        restore_params = {is_deleted: false, deleted_at: nil, deleted_by_id: nil, deleted_reason: nil,
          deleted_due_to_parent: false}

        # 連鎖復元対象外(復元しない)
        if @restored_via_parent && !@group_post.deleted_due_to_parent
          Rails.logger.info("#{self.class.name}: 
            連鎖復元対象外のグループ内投稿の復元をスキップしました (id: #{@group_post.id})")
          return

        # 親の連鎖削除で削除されたものを復元
        elsif @restored_via_parent && @group_post.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 個別の復元
        elsif !@restored_via_parent && !@group_post.deleted_due_to_parent
          # 親の状態を確認、親がアクティブな場合、復元を行う
          if !@group_post.member.member_status_active?
            raise '投稿を行ったメンバーが削除されているため復元出来ませんでした'
          end

          restore_params[:is_public] = false

        # 想定していないエラー
        else
          raise "#{self.class.name}で想定外のエラーが発生しました"
        end

        @group_post.update!(restore_params)

        # 子要素の連鎖復元
        @group_post.group_post_comments.each do |comment|
          Restorer::GroupPostCommentRestorer.new(comment, restored_via_parent: true).call
        end
      end
    end
  end
end