class Public::SearchesController < ApplicationController
  before_action :set_types

   def index
    # 検索条件のログ出力（デバッグ用）
    Rails.logger.debug("params[:type]: #{params[:type]}")
    Rails.logger.debug("params[:words]: #{params[:words]}")
    Rails.logger.debug("params[:not_words]: #{params[:not_words]}")

    @words = extract_keywords(params[:words])
    @not_words = extract_keywords(params[:not_words])

    # カテゴリーを付けて検索結果の表示時に区別
    @results = 
    if @search_type.include?("すべて")
      @results = 
      [
        { category: @decide_types[0], records: search_users },
        { category: @decide_types[1], records: search_user_posts },
        { category: @decide_types[2], records: search_groups },
        { category: @decide_types[3], records: search_group_posts }
      ]
    else
      case @search_type
      when @decide_types[0]
        [{ category: @decide_types[0], records: search_users }]
      when @decide_types[1]
        [{ category: @decide_types[1], records: search_user_posts }]
      when @decide_types[2]
        [{ category: @decide_types[2], records: search_groups }]
      when @decide_types[3]
        [{ category: @decide_types[3], records: search_group_posts }]
      else
        []
      end
    end
  end

  private

  def search_model_optimized(model_class, search_fields)
    # ワードと除外ワードをパラメータから抽出
    words = extract_keywords(params[:words])
    not_words = extract_keywords(params[:not_words])
    query = model_class.all
  
    # 例： (name LIKE ? OR bio LIKE ?) OR (name LIKE ? OR bio LIKE ?)
    if words.present?
      # 各ワードに対して、検索対象フィールドすべてにLIKE検索をかけ、ORで繋ぐ
      word_sql = words.map { |word| 
        search_fields.map { |field| "#{field} LIKE ?" }.join(" OR ") }.join(" OR ")
      word_values = words.flat_map { |word| search_fields.map { "%#{word}%" } }

      # SQLを1つのwhereでまとめて発行(クエリの数を抑える)
      query = query.where(word_sql, *word_values)
    end
  
    # 除外したいキーワードもまとめて1回で除外
    if not_words.present?
      not_sql = not_words.map { |word| 
        search_fields.map { |field| "#{field} LIKE ?" }.join(" OR ") }.join(" OR ")
      not_values = not_words.flat_map { |word| search_fields.map { "%#{word}%" } }
      query = query.where.not(not_sql, *not_values)
    end
  
    query
  end
  
  # 各モデルに応じた検索メソッド
  def search_users
    search_model_optimized(User, %w[nickname bio]).page(params[:page])
  end

  def search_user_posts
    search_model_optimized(Post, %w[title body]).page(params[:page])
  end

  def search_groups
    raise NotImplementedError, 'グループ検索は未実装です' # 実装予定ならここを変更
  end

  def search_group_posts
    raise NotImplementedError, 'グループ内投稿検索は未実装です' # 実装予定ならここを変更
  end

  # 入力が空なら空配列を返す、全角スペースを半角にし、記号を削除し、文字列の前後の空白を取り除く
  # 半角スペース(またはそれに類する空白)で単語を分割して配列にする  
  def extract_keywords(text)
    return [] if text.blank?

    sanitized = text.tr('　', ' ').gsub(/[[:punct:]]/, '').strip
    sanitized.split(/\s+/)
  end

  # 検索種別をセットする、検索結果の表示は@search_typeが軸なので拡張時不正な値にならないように気を付ける
  def set_types
    @decide_types = PostConstants::SEARCH_TYPES
    @search_type = params[:type]
  end
end