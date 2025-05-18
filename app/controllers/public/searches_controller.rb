class Public::SearchesController < ApplicationController
  before_action :set_search_types

  def index
    @results = []

    # 'ユーザー'の検索を実行する場合
    if params[:types].include?("ユーザー")
      search_users
    end

    # '投稿'の検索を実行する場合
    if params[:types].include?("投稿")
      search_posts
    end

    # その他の検索タイプを追加する場合
    # ...

    # 検索結果をビューに渡す
    @results
  end

  private

  # 検索タイプに基づく検索処理（ユーザー）
  def search_users
    q = User.ransack(
      last_name_or_first_name_or_nickname_or_bio_cont: params[:q],  # 検索条件
      last_name_or_first_name_or_nickname_or_bio_not_cont: params[:not_q].presence
    )
    @results += q.result(distinct: true).to_a  # 結果を追加
  end

  # 投稿の検索メソッド
  def search_posts
    q = Post.ransack(
      title_or_body_cont: params[:q],  # 投稿のタイトルやボディで検索
      title_or_body_not_cont: params[:not_q].presence
    )
    @results += q.result(distinct: true).to_a  # 結果を追加
  end

  # 検索タイプを事前に設定
  def set_search_types
    @search_types = PostConstants::SEARCH_TYPES
  end
end
