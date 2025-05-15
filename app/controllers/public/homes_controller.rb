class Public::HomesController < ApplicationController
# コントローラ（app/controllers/public/homes_controller.rb）

  def top
    # 投稿が足りない場合に表示するダミー画像の数を計算
    @recent_posts = Post.order(created_at: :desc)
                      .where('created_at >= ?', Time.now - PostConstants::POSTS_RANGE_DAYS.days)
                      .limit(PostConstants::MAX_DISPLAY_COUNT)

    # 投稿がない場合も空の配列を設定
    @recent_posts ||= []

    # ダミー画像を表示するために足りない分の投稿数を計算
    @dummy_image_count = [PostConstants::MAX_DISPLAY_COUNT - @recent_posts.size, 0].max

    # ダミー画像の番号を生成するためにWhispersOfLuckを使う
    whisper_of_luck = HomesHelper::WhispersOfLuck.new(PostConstants::MAX_DISPLAY_COUNT)

    # ダミー画像用の番号を取得
    @dummy_images = whisper_of_luck.generate_lucky_numbers
  end




  def about
  end
end
