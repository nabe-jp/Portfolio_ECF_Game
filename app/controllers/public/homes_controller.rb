class Public::HomesController < ApplicationController

  def top
    # --- ユーザー投稿の取得 ---
    # 投稿が足りない場合に表示するダミー画像の数を計算
    @recent_user_posts, @user_post_dummy_images = generate_recent_posts_and_dummy_images(
      UserPost.where('created_at >= ?', Time.now - PostConstants::POSTS_RANGE_DAYS.days)
        .active_posts_desc, 
          PostConstants::MAX_DISPLAY_COUNT)

    # --- グループ投稿の取得---
    @recent_group_posts, @group_post_dummy_images = generate_recent_posts_and_dummy_images(
      GroupPost.where('created_at >= ?', Time.now - PostConstants::POSTS_RANGE_DAYS.days)
        .active_group_posts_for_all_desc, 
          PostConstants::MAX_DISPLAY_COUNT)
 
    # --- 情報お知らせの取得 ---
    # 固定情報（is_pinned: true）を sort_order → published_at 降順 で並べる
    pinned_info = Information.active_information_pinned

    # 通常情報（is_pinned: false）を published_at 降順で並べる
    unpinned_info = Information.active_information_not_pinned

    # 上に固定を、下に通常を結合
    @information_list = pinned_info + unpinned_info
  end

  def about; end

  private

  def generate_recent_posts_and_dummy_images(posts, max_count)
    posts = posts.limit(max_count)

    # ダミー画像を表示するために足りない分の投稿数を計算
    dummy_count = [max_count - posts.size, 0].max

    # ダミー画像の番号を生成するためにWhispersOfLuckを使う
    dummy_images = Homes::WhispersOfLuck.new(dummy_count).generate_lucky_numbers
    [posts, dummy_images]
  end
end
