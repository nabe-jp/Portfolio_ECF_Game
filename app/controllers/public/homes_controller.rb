class Public::HomesController < ApplicationController

  def top
    # --- ユーザー投稿の取得 ---
    # 投稿が足りない場合に表示するダミー画像の数を計算
    @recent_user_posts = UserPost.where('created_at >= ?', 
      Time.now - ::PostConstants::POSTS_RANGE_DAYS.days).where(is_public: true, is_deleted: false)
        .order(created_at: :desc).limit(PostConstants::MAX_DISPLAY_COUNT)

    # ダミー画像を表示するために足りない分の投稿数を計算
    dummy_image_count = (PostConstants::MAX_DISPLAY_COUNT - @recent_user_posts.size || 0)

    # ダミー画像の番号を生成するためにWhispersOfLuckを使う
    whisper_of_luck = HomesHelper::WhispersOfLuck.new(dummy_image_count)

    # ダミー画像用の番号を取得
    @dummy_images = whisper_of_luck.generate_lucky_numbers

    # --- グループ投稿の取得(グループ投稿はまだ調整中のため該当しない) ---
    # @recent_group_posts = GroupPost.where('created_at >= ?', 
    #   Time.now - ::PostConstants::POSTS_RANGE_DAYS.days).where(is_public: true, is_deleted: false)
    #     .order(created_at: :desc).limit(PostConstants::MAX_DISPLAY_COUNT)
    @recent_group_posts = []

    # ダミー画像を表示するために足りない分の投稿数を計算
    dummy_image_count = (PostConstants::MAX_DISPLAY_COUNT - @recent_group_posts.size || 0)

    # ダミー画像の番号を生成するためにWhispersOfLuckを使う
    whisper_of_luck = HomesHelper::WhispersOfLuck.new(dummy_image_count)

    # ダミー画像用の番号を取得
    @group_post_dummy_images = whisper_of_luck.generate_lucky_numbers

    # --- 情報お知らせの取得 ---
    # 固定情報（is_pinned: true）を sort_order → published_at 降順 で並べる
    pinned_info = Information
      .where(is_public: true, deleted_at: nil, is_pinned: true)
      .order(:sort_order, published_at: :desc)

    # 通常情報（is_pinned: false）を published_at 降順で並べる
    unpinned_info = Information
      .where(is_public: true, deleted_at: nil, is_pinned: false)
      .order(published_at: :desc)

    # 上に固定を、下に通常を結合
    @information_list = pinned_info + unpinned_info

  end

  def about
  end
end
