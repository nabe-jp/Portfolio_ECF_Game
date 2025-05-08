class Public::HomesController < ApplicationController
  def top
        # 現在の日付から過去1週間以内の投稿を取得し、4件だけ表示
        @recent_posts = Post.where('created_at >= ?', 1.week.ago).limit(4)
  end

  def about
  end
end
