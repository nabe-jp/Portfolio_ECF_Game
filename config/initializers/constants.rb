module PostConstants
  Rails.logger.info "PostConstants モジュールの読み込み開始！"

  # 絶対数の管理
  MAX_DISPLAY_COUNT = 5          # トップページなどでの表示数上限(/件)
  POSTS_RANGE_DAYS = 7           # 最近の投稿の表示期間(/日)

  # 文字列の管理
  # 検索フォームで使用
  SEARCH_TYPES = %w[ユーザー 投稿 グループ グループ内投稿].freeze
  
  # トップページで使用
  NOTIFICATION_TITLE = "お知らせ"
  LATEST_POST_TITLE = "最新の投稿"
  LATEST_GROUP_POST_TITLE = "最新のグループ投稿"
  TODAY_TOP_LIKES_TITLE = "本日のいいねTOP"

  Rails.logger.info "PostConstants モジュールの読み込み完了！"
end