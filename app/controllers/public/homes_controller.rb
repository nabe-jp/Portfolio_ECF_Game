class Public::HomesController < ApplicationController
  def top
    @all_posts = Post.order(created_at: :desc)

    # 現在の日付から過去1週間以内の投稿を取得し、constantsで設定してある件数だけ表示
    @recent_posts = @all_posts.limit(PostConstants::MAX_DISPLAY_COUNT)
  end

  def about
  end
end
