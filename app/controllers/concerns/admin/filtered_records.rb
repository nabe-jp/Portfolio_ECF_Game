module Admin::FilteredRecords
  # 投稿一覧の絞り込みロジック
  def filtered_records(model_class)
    #includesを使用し、N+1回避のために読み込む
    base =
    case model_class.name
    when "UserPost", "UserPostComment"
      model_class.includes(:user)
    when "GroupEvent", "GroupNotice"
      model_class.includes(member: :user)
    when "GroupPost"
      model_class.includes(member: :user)
    when "GroupPostComment"
      model_class.includes(:group_post, member: :user)
    when "GroupMembership"
      model_class.includes(:user)
    else
      model_class.all
    end

    # 表示状態の組み合わせに応じてスコープを適用
    if @show_all
      base                                                                          # すべての投稿を表示
    elsif @show_non_public && @show_deleted
      base.merge(model_class.hidden_only).or(base.merge(model_class.deleted_only))  # 非公開と削除済みを表示
    elsif @show_non_public
      merged_scope = model_class.hidden_only.undeleted_only                         # 1回のmergeで済むよう定義
      base.merge(merged_scope)                                                      # 非公開のみ表示
    elsif @show_deleted
      base.merge(model_class.deleted_only)                                          # 削除済みのみ表示
    else
      base.merge(model_class.active_only)                                           # 初期状態：公開のみ表示
    end
  end

  # enumで状態管理されるモデル用(例: GroupMembership, User)
  # scopeは ActiveRecord::Relation (e.g. User.all や @group.group_memberships)
  def filtered_records_for_enum_status(scope)
    # モデルクラスの名前を返してくれる
    case scope.klass.name

    when "User"
      case params[:status]
      when "active"
        scope.where(user_status: :active)
      when "not_active"
        scope.where.not(user_status: :active)
      when "deactivated"
        scope.where(user_status: :deactivated)
      when "restored_pending"
        scope.where(user_status: :restored_pending)
      when "banned"
        scope.where(user_status: :banned)
      when "suspended"
        scope.where(user_status: :suspended)
      else
        scope.all
      end

    when "GroupMembership"
      case params[:status]
      when "active"
        scope.where(member_status: :active)
      when "not_active"
        scope.where.not(member_status: :active)
      when "pending"
        scope.where(member_status: :pending)
      when "rejected"
        scope.where(member_status: :rejected)
      when "inactive"
        scope.where(member_status: :inactive)
      when "kicked"
        scope.where(member_status: :kicked)
      when "suspended"
        scope.where(member_status: :suspended)
      else
        scope.all
      end

    else
      scope.none # 未対応モデルには空を返す
    end
  end

  # 並び順の判定と返却(created_at, id の複合キー)
  def sort_order
    direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"
    [{ created_at: direction }, { id: direction }]                                  # 作成日時 → ID の順
  end
end