# グループ情報の設定とグループで使用するアクセス制限(リダイレクト指定のあるものはbefore_actionで使用)
module Public::AuthorizeGroup
  # included do ... endを使えるようにし、モジュールを取り込んだコントローラーで自動的に特定の処理を実行する
  extend ActiveSupport::Concern

  included do
    before_action :set_group
  end

  private
  #-- メソッド用 --
  # 単体テストなどの可能性も含めてメソッド化、トップ階層は:slug]、ネスト階層は:group_slugなので柔軟に対応
  def set_group
    slug = params[:group_slug] || params[:slug]
    @group = Group.find_by!(slug: slug)
  end
  
  # メンバー内から自身の情報の取得に使用(同じアクション内で呼ばれた際に再度取得しないようにキャッシュ化)
  def current_membership
    @current_membership ||= @group.group_memberships.active_members.find_by(user_id: current_user.id)
  end

  # メンバーであるかの判定をメソッド化
  def group_member?
    current_membership.present?
  end

  # オーナーであるかの判定をメソッド化
  def group_owner?
    current_membership&.role_owner?
  end

  # グループ管理者かどうかの判定をメソッド化
  def group_moderator?
    group_owner? || current_membership&.role_moderator?
  end

   # イベントの編集・削除権限の判定をメソッド化
   def group_event_editor?
    group_moderator? || @group_event.member.user == current_user
  end

  # 投稿の編集・削除権限の判定をメソッド化
  def group_post_editor?
    group_moderator? || @group_post.member.user == current_user
  end

  # 親コメントの編集・削除権限の判定をメソッド化
  def group_post_top_level_comment_editor?(comment)
    group_post_editor? || comment.member.user == current_user
  end

  # 子コメントの編集・削除権限の判定をメソッド化
  def group_post_reply_comment_editor?(reply)
    group_post_editor? || reply.member.user == current_user
  end
  
  # 上記二つをまとめたコメントの編集・削除権限の判定をメソッド化
  def group_post_comment_editor?(comment)

    if comment.parent_comment_id.nil?
      group_post_top_level_comment_editor?(comment)
    else
      group_post_reply_comment_editor?(comment)
    end
  end

  # 現在のユーザーが自身より上または同等の権限を持つ相手に対して操作を試みた場合に拒否
  def prohibit_operating_higher_or_equal_role!(target_membership)
    return if current_membership.nil?

    current_level = GroupMembership.roles[current_membership.role]
    target_level = GroupMembership.roles[target_membership.role]

    if target_level >= current_level
      redirect_to group_member_path(@group, target_membership),
        alert: "自身より上または同等の権限を持つユーザーには操作できません。" and return true
    end
  end

  # 現在のユーザーが上位権限を付与しようとする操作を試みた場合に拒否
  def prohibit_assigning_higher_role!(new_role)
    current_level = GroupMembership.roles[current_membership.role]
    new_role_level = GroupMembership.roles[new_role]
  
    if new_role_level > current_level
      redirect_to group_member_path(@group, @membership),
        alert: "自身より上の権限を付与することはできません。" and return true
    end
  end

  #-- before_action用 --
  # メンバーであるかの判定
  def authorize_group_member!
    unless group_member?
      redirect_to group_path(@group), alert: "このグループのメンバーのみアクセスできます。"
    end
  end

  # オーナーであるかの判定
  def authorize_group_owner!
    unless group_owner?
      redirect_to group_path(@group), alert: "グループのオーナーのみアクセスできます。"
    end
  end

  # 管理者であるかの判定
  def authorize_group_moderator!
    unless group_moderator?
      redirect_to group_path(@group), alert: "管理者権限が必要です。"
    end
  end

  # イベントの編集・削除権限の判定
   def authorize_group_event_editor!
    unless group_event_editor?
      redirect_to group_event_path(@group, @group_event), alert: "イベントの編集・削除権限がありません。"
    end
  end

  # 投稿の編集・削除権限判定
  def authorize_group_post_editor!
    unless group_post_editor?
      redirect_to group_post_path(@group, @group_post), alert: "投稿の編集・削除権限がありません。"
    end
  end

  # コメントの編集・削除権限判定
  def authorize_group_post_comment_editor!
    unless group_post_comment_editor?(@comment)
      redirect_to group_post_path(@group, @group_post), alert: "コメントの編集・削除権限がありません。"
    end
  end
end
