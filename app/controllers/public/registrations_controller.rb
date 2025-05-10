class Public::RegistrationsController < Devise::RegistrationsController
  # Deviseの登録機能をオーバーライドしたいときに使用

  # エラーメッセージに使用するヘルパーメソッドの読み込み
  include ErrorsHelper

  # ユーザーのサインアップ処理の前に特定のパラメータを許可する
  before_action :configure_sign_up_params, only: [:create]

  # ログインに必要なユーザー情報の更新に使用
  before_action :configure_account_update_params, only: [:update]

  # フラッシュに以前の入力がある場合はその情報をもとに@userを作成、なければ空の新規ユーザーを作成
  def new
    if flash[:user_attributes]
      build_resource(flash[:user_attributes])
    else
      build_resource({})
    end
    respond_with resource
  end

  # 新規会員登録ページでリダイレクト発生時アドレスバーが変わるのを防ぐ目的でcreateアクションをオーバーライド
  def create
    build_resource(sign_up_params)
    if resource.save
      sign_up(resource_name, resource)
      redirect_to after_sign_up_path_for(resource), notice: "アカウント登録が完了しました"
    else
      flash[:user_attributes] = sign_up_params                     # 入力内容を一時保存
      flash[:error_messages] = 
        reorder_error_messages(resource, [:email, :password])      # エラーメッセージを並び替えて一時保存
      clean_up_passwords resource                                  # パスワードのクリーンアップ
      redirect_to new_user_registration_path
    end
  end

  protected

  # 新規登録後のリダイレクト先
  def after_sign_up_path_for(resource)
    user_mypage_path(resource)
  end

  # アカウント更新後のリダイレクト先（任意で追加）
  def after_update_path_for(resource)

  end

  # サインアップ時に許可するパラメータ
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :nickname, :bio])
  end

  # アカウント更新時に許可するパラメータ
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:last_name, :first_name, :nickname, :bio])
  end
end
