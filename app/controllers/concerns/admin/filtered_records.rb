module Admin::FilteredRecords
    # 投稿一覧の絞り込みロジック
    def filtered_records(model_class)
      base = model_class.includes(:user)                         # N+1回避のためにユーザー情報を事前読み込み

      # 各表示状態に対応するスコープを定義(独立していて互いに影響を与えない)
      public_scope     = model_class.where(is_public: true, is_deleted: false)
      non_public_scope = model_class.where(is_public: false, is_deleted: false)
      deleted_scope    = model_class.where(is_deleted: true)

    # 表示状態の組み合わせに応じてスコープを適用
    if @show_all
      base  # すべての投稿を表示
    elsif @show_non_public && @show_deleted
      base.merge(non_public_scope.or(deleted_scope))            # 非公開と削除済みを両方表示
    elsif @show_non_public
      base.merge(non_public_scope)                              # 非公開のみ表示
    elsif @show_deleted
      base.merge(deleted_scope)                                 # 削除済みのみ表示
    else
      base.merge(public_scope)                                  # 初期状態：公開中のみ表示
    end
  end

  # 並び順の判定と返却(created_at, id の複合キー)
  def sort_order
    direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"
    [{ created_at: direction }, { id: direction }]              # 作成日時 → ID の順で並べる
  end
end