class Public::SessionsController < Devise::SessionsController
  # 入力フォームに表示する表記の読み込み(バリデーションに使用する絶対値を用いて表示)
  helper Public::PlaceholdersHelper
  
  # ログイン失敗時にエラーメッセージをflash[:error_messages]し新規会員登録側と表示を合わせる為に作成
  # オーバライドしたので退会ユーザーかのチェックも行う
  def create
    
    # 入力されたメールアドレスに該当するユーザーを探し、そのユーザーをresourceにセット
    self.resource = User.find_for_authentication(email: params[:user][:email])

    # ユーザーが見つかり、パスワードが合っているか確認、退会していなければDevise標準のログイン処理を行う
    if resource && resource.valid_password?(params[:user][:password])
      if resource.user_status_active?
        super
      else
        flash[:error_name] = 'ログイン'
        flash[:error_messages] = ['退会済みアカウントの為、使用できません']
        redirect_to new_user_session_path
      end
    else
      # エラーメッセージがある場合にflash[:error_messages]にセット
      flash[:error_name] = 'ログイン'
      flash[:error_messages] = ['メールアドレスかパスワードが正しくありません']
      redirect_to new_user_session_path
    end
  end

  protected

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    root_path
  end

  # ログインアウト後のリダイレクト先
  def after_sign_out_path_for(resource)
    root_path
  end
end