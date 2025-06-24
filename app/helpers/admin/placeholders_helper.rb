module Admin::PlaceholdersHelper
  def information_title_placeholder
    "タイトルを#{Information::TITLE_MIN_LENGTH}〜#{Information::TITLE_MAX_LENGTH}文字で入力してください"
  end

  def information_body_placeholder
    "内容を#{Information::BODY_MIN_LENGTH}〜#{Information::BODY_MAX_LENGTH}文字で入力してください"
  end

  def admin_note_title_placeholder
    "タイトルを#{AdminNote::TITLE_MIN_LENGTH}〜#{AdminNote::TITLE_MAX_LENGTH}文字で入力してください"
  end

  def admin_note_body_placeholder
    "内容を#{AdminNote::BODY_MIN_LENGTH}〜#{AdminNote::BODY_MAX_LENGTH}文字で入力してください"
  end  
end