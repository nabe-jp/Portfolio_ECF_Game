module Restorer
  class GroupMemberRestorer
    def initialize(member, restored_via_parent: false)
      @member = member
      @restored_via_parent = restored_via_parent
    end

    def call
      ActiveRecord::Base.transaction do
        restore_params = {member_status: :active, deleted_at: nil, deleted_by_id: nil,
          deleted_reason: nil, deleted_due_to_parent: false}

        if @member.group.is_deleted || !@member.user.user_status_active?
          raise 'グループまたはユーザーが削除されているため復元出来ませんでした'
            
        # 親の連鎖削除で削除されたものを復元
        elsif @restored_via_parent && @member.deleted_due_to_parent
          restore_params[:hidden_on_parent_restore] = true

        # 連鎖復元対象外(復元しない)
        elsif @restored_via_parent && !@member.deleted_due_to_parent
          Rails.logger.info("#{self.class.name}: 
            連鎖復元対象外のメンバー情報の復元をスキップしました (id: #{@member.id})")
          return

        # 個別の復元
        elsif !@restored_via_parent && !@member.deleted_due_to_parent
          restore_params[:is_public] = false

        # 想定していないエラー
        else
          raise "#{self.class.name}で想定外のエラーが発生しました"
        end

        @member.update!(restore_params)

        # 子要素の連鎖復元
        @member.group_events.each do |event|
          Restorer::GroupEventRestorer.new(event, restored_via_parent: true).call
        end

        @member.group_notices.each do |notice|
          Restorer::GroupNoticeRestorer.new(notice, restored_via_parent: true).call
        end

        @member.group_posts.each do |post|
          Restorer::GroupPostRestorer.new(post, restored_via_parent: true).call
        end

        @member.group_post_comments.each do |comment|
          Restorer::GroupPostCommentRestorer.new(comment, restored_via_parent: true).call
        end
      end
    end
  end
end