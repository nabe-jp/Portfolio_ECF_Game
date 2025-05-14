module UserPasswordUpdaterHelper
  def check_password_errors(user, new_password, password_confirmation, current_password)
    errors = []

    # 新しいパスワードが空か判定
    if new_password.blank?
      errors << "新しいパスワードは必須です"
    elsif user.valid_password?(new_password)
      errors << "新しいパスワードは現在のパスワードと同じです"
    elsif new_password.length < Devise.password_length.first || 
      new_password.length > Devise.password_length.last
      errors << "新しいパスワードは #{Devise.password_length.first}文字以上、
        #{Devise.password_length.last}文字以内でなければなりません"
    end

    # パスワード確認用が空か判定
    if password_confirmation.blank?
      errors << "パスワード確認は必須です"
    # 新しいパスワードと確認用パスワードが一致しているか判定
    elsif new_password != password_confirmation
      errors << "新しいパスワードと確認用パスワードが一致しません"
    end

    # 現在のパスワードが空か判定
    if current_password.blank?
      errors << "現在のパスワードは必須です"
    # 現在のパスワードが正しいか判定
    elsif !user.valid_password?(current_password)
      errors << "現在のパスワードが間違っています"
    end

    errors
  end
end