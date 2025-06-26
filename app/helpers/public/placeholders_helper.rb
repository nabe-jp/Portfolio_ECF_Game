module Public::PlaceholdersHelper

  # --- アドミン、ユーザー共通 ---
  def email_placeholder
    "sample@example.com"
  end

    # --- ユーザー ---
  def user_last_name_placeholder
    "姓を#{User::REAL_NAME_MIN_LENGTH}〜#{User::REAL_NAME_MAX_LENGTH}文字で入力してください"
  end

  def user_first_name_placeholder
    "名を#{User::REAL_NAME_MIN_LENGTH}〜#{User::REAL_NAME_MAX_LENGTH}文字で入力してください"
  end

  def user_nickname_placeholder
    "ニックネームを#{User::NICKNAME_MIN_LENGTH}〜#{User::NICKNAME_MAX_LENGTH}文字で入力してください"
  end

  def user_bio_placeholder
    "自己紹介を#{User::BIO_MIN_LENGTH}〜#{User::BIO_MAX_LENGTH}文字で入力してください"
  end

  # --- ユーザー投稿 ---
  def user_post_title_placeholder
    "タイトルを#{UserPost::TITLE_MIN_LENGTH}〜#{UserPost::TITLE_MAX_LENGTH}文字で入力してください"
  end

  def user_post_body_placeholder
    "内容を#{UserPost::BODY_MIN_LENGTH}〜#{UserPost::BODY_MAX_LENGTH}文字で入力してください"
  end

  # --- ユーザー投稿コメント ---
  def user_post_comment_body_placeholder
    "コメントを#{UserPostComment::BODY_MIN_LENGTH}〜#{UserPostComment::BODY_MAX_LENGTH}文字で入力してください"
  end

  def user_post_comment_reply_body_placeholder
    "返信コメントを#{UserPostComment::BODY_MIN_LENGTH}〜#{UserPostComment::BODY_MAX_LENGTH}文字で入力してください"
  end

  # --- グループ ---
  def group_name_placeholder
    "グループ名を#{Group::NAME_MIN_LENGTH}〜#{Group::NAME_MAX_LENGTH}文字で入力してください"
  end

  def group_description_placeholder
    "説明を#{Group::DESCRIPTION_MIN_LENGTH}〜#{Group::DESCRIPTION_MAX_LENGTH}文字で入力してください"
  end

  def group_slug_placeholder
    "スラッグはを#{Group::SLUG_MIN_LENGTH}〜#{Group::SLUG_MAX_LENGTH }文字、英数字とハイフンのみで入力してください"
  end

  # --- 管理者メモ ---
  def group_member_note_placeholder
    "メモを#{GroupMembership::NOTE_MAX_LENGTH}文字以内で入力してください"
  end

  # --- グループ内お知らせ ---
  def group_notice_title_placeholder
    "タイトルを#{GroupPost::TITLE_MIN_LENGTH}〜#{GroupPost::TITLE_MAX_LENGTH}文字で入力してください"
  end

  def group_notice_body_placeholder
    "内容を#{GroupNotice::BODY_MIN_LENGTH}〜#{GroupNotice::BODY_MAX_LENGTH}文字で入力してください"
  end

  # --- グループ内イベント ---
  def group_event_title_placeholder
    "タイトルを#{GroupEvent::TITLE_MIN_LENGTH}〜#{GroupEvent::TITLE_MAX_LENGTH}文字で入力してください"
  end
  
  def group_event_description_placeholder
    "説明を#{GroupEvent::DESCRIPTION_MIN_LENGTH}〜#{GroupEvent::DESCRIPTION_MAX_LENGTH}文字で入力してください"
  end

  # --- グループ内投稿 ---
  def group_post_title_placeholder
    "タイトルを#{GroupPost::TITLE_MIN_LENGTH}〜#{GroupPost::TITLE_MAX_LENGTH}文字で入力してください"
  end

  def group_post_body_placeholder
    "内容を#{GroupPost::BODY_MIN_LENGTH}〜#{GroupPost::BODY_MAX_LENGTH}文字で入力してください"
  end

  # --- グループ内投稿コメント ---
  def group_post_comment_body_placeholder
    "コメントを#{GroupPostComment::BODY_MIN_LENGTH}〜#{GroupPostComment::BODY_MAX_LENGTH}文字で入力してください"
  end

  def group_post_comment_reply_body_placeholder
    "返信コメントを#{GroupPostComment::BODY_MIN_LENGTH}〜#{GroupPostComment::BODY_MAX_LENGTH}文字で入力してください"
  end
end