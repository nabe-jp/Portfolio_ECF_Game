class Public::HomesController < ApplicationController

  def top
    # --- ユーザー投稿の取得 ---
    # 投稿が足りない場合に表示するダミー画像の数を計算
    @recent_user_posts, @dummy_images = generate_recent_posts_and_dummy_images(
      UserPost.where('created_at >= ?', Time.now - PostConstants::POSTS_RANGE_DAYS.days).active_posts_desc,
      PostConstants::MAX_DISPLAY_COUNT)

    # --- グループ投稿の取得(グループ投稿はまだ調整中のため該当しない) ---
    # @recent_group_posts = GroupPost.where('created_at >= ?', 
    #   Time.now - ::PostConstants::POSTS_RANGE_DAYS.days).active_group_posts_for_all_desc
    #     .limit(PostConstants::MAX_DISPLAY_COUNT)
    @recent_group_posts = []

    # ダミー画像を表示するために足りない分の投稿数を計算
    dummy_image_count = (PostConstants::MAX_DISPLAY_COUNT - @recent_group_posts.size || 0)

    # ダミー画像の番号を生成するためにWhispersOfLuckを使う
    whisper_of_luck = HomesHelper::WhispersOfLuck.new(dummy_image_count)

    # ダミー画像用の番号を取得
    @group_post_dummy_images = whisper_of_luck.generate_lucky_numbers

    # --- 情報お知らせの取得 ---
    # 固定情報（is_pinned: true）を sort_order → published_at 降順 で並べる
    pinned_info = Information.active_information_pinned

    # 通常情報（is_pinned: false）を published_at 降順で並べる
    unpinned_info = Information.active_information_not_pinned

    # 上に固定を、下に通常を結合
    @information_list = pinned_info + unpinned_info
  end

  def about
  end

  private

  def generate_recent_posts_and_dummy_images(posts, max_count)
    posts = posts.limit(max_count)

    # ダミー画像を表示するために足りない分の投稿数を計算
    dummy_count = [max_count - posts.size, 0].max

    # ダミー画像の番号を生成するためにWhispersOfLuckを使う
    dummy_images = HomesHelper::WhispersOfLuck.new(dummy_count).generate_lucky_numbers
    [posts, dummy_images]
  end
end
