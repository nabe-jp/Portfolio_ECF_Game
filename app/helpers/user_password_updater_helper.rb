module UserPasswordUpdaterHelper
  def update_password_for_user(user, params)
    errors = []

    # 新しいパスワードが空か判定
    if params[:user][:new_password].blank?
      errors << "新しいパスワードは必須です"
    # 新しいパスワードが現在のパスワードと一致するか判定
    elsif user.valid_password?(params[:user][:new_password])
      errors << "新しいパスワードは現在のパスワードと同じです"
    # 新しいパスワードの長さが正しいか判定
    elsif params[:user][:new_password].length < Devise.password_length.first || 
          params[:user][:new_password].length > Devise.password_length.last
      errors << "新しいパスワードは #{Devise.password_length.first}文字以上、#{Devise.password_length.last}文字以内でなければなりません"
    end

    # パスワード確認用が空か判定
    if params[:user][:password_confirmation].blank?
      errors << "パスワード確認は必須です"
    # 新しいパスワードと確認用パスワードが一致しているか判定
    elsif params[:user][:new_password] != params[:user][:password_confirmation]
      errors << "新しいパスワードと確認用パスワードが一致しません"
    end

    # 現在のパスワードが空か判定
    if params[:user][:current_password].blank?
      errors << "現在のパスワードは必須です"
    # 現在のパスワードが正しいか判定
    elsif !user.valid_password?(params[:user][:current_password])
      errors << "現在のパスワードが間違っています"
    end

    errors
  end
end