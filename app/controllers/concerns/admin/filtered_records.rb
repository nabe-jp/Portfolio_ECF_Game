module Admin::FilteredRecords
    # 投稿一覧の絞り込みロジック
    def filtered_records(model_class)
      base = model_class.includes(:user)                                            # N+1回避のために読み込む

    # 表示状態の組み合わせに応じてスコープを適用
    if @show_all
      base  # すべての投稿を表示
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

  # 並び順の判定と返却(created_at, id の複合キー)
  def sort_order
    direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"
    [{ created_at: direction }, { id: direction }]              # 作成日時 → ID の順で並べる
  end
end