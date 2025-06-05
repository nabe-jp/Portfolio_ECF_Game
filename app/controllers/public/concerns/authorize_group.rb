module Public::Concerns::AuthorizeGroup
  # included do ... endを使えるようにし、モジュールを取り込んだコントローラーで自動的に特定の処理を実行する
  extend ActiveSupport::Concern

  included do
    before_action :set_group
  end

  private

  def set_group
    @group = Group.find_by!(slug: params[:group_slug])
  end
  
  def authorize_group_member!
    unless @group.members.include?(current_user)
      redirect_to group_path(@group), alert: "このグループのメンバーのみアクセスできます。"
    end
  end

  def authorize_group_moderator!
    unless @group.group_memberships.exists?(user_id: current_user.id, role: :moderator) || 
        @group.owner == current_user
      redirect_to group_path(@group), alert: "管理者権限が必要です。"
    end
  end
  
  def authorize_group_owner!
    unless @group.owner == current_user
      redirect_to group_path(@group), alert: "グループのオーナーのみアクセスできます。"
    end
  end
end
