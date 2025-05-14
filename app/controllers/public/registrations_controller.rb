class Public::RegistrationsController < Devise::RegistrationsController
  # エラーメッセージの並べ替え、editでの表示画面の分岐、パスワードの判定を行うヘルパーメソッドの読み込み
  include ErrorsHelper
  include UserPasswordUpdaterHelper
  include UserRegistrationHelper

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # フラッシュに以前の入力がある場合はその情報をもとに@userを作成、なければ空の新規ユーザーを作成
  def new
    if flash[:user_attributes]
      build_resource(flash[:user_attributes])
    else
      build_resource({})
    end
    # resource(@user)をビューに渡してフォームを表示
    respond_with resource
  end

  # 新規会員登録ページでリダイレクト発生時アドレスバーが変わるのを防ぐ目的でcreateアクションをオーバーライド
  def create
    build_resource(sign_up_params)
    if resource.save
      sign_up(resource_name, resource)
      redirect_to after_sign_up_path_for(resource), notice: "アカウント登録が完了しました"
    else
      # パスワードのクリーンアップ
      clean_up_passwords resource
      # フラッシュにデータとエラーを保持して再表示
      store_form_data(attributes: sign_up_params, 
        error_keys: [:email, :password], form_type: :sign_up, error_name: "新規会員登録")
      redirect_to new_user_registration_path and return
    end
  end
  
  def edit
    # エラー時にはフラッシュが入力を保持し、入力情報がない場合(初回表示時)は現在のユーザー情報をそのまま利用
    if flash[:user_attributes]
      build_resource(flash[:user_attributes])
    else
      build_resource(resource.attributes)
    end
    # 受け取った情報をもとに表示フォームを変更
    set_edit_form_type(params)
    # 親クラスを呼び出し処理を引き継ぐ
    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if params[:user][:form_type] == "password"
      handle_password_update
    elsif params[:user][:form_type] == "profile"
      handle_profile_update
    end
  end

  protected

  # 新規登録後のリダイレクト先
  def after_sign_up_path_for(resource)
    user_mypage_path
  end

  # アカウント更新後のリダイレクト先（任意で追加）
  def after_update_path_for(resource)
    user_mypage_path
  end

  # サインアップ時に許可するパラメータ
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :nickname, :bio])
  end

  # アカウント更新時に許可するパラメータ
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:last_name, :first_name])
  end

  private
  # パスワード更新処理、プロフィール更新処理、パラメーター保持はヘルパーメソッドを使わずprivate下に配置

  # パスワードのエラー、更新処理
  def handle_password_update
    new_password = params[:user][:new_password]
    password_confirmation = params[:user][:password_confirmation]
    current_password = params[:user][:current_password]

    # ヘルパーメソッドを使ってパスワード更新ロジックを実行
    errors = check_password_errors(resource, new_password, password_confirmation, current_password)
    if errors.any?
      flash[:error_name] = "パスワード更新"
      errors.each { |error| resource.errors.add(:base, error) }
      flash[:error_messages] = resource.errors.full_messages
      redirect_to edit_user_registration_path(password: true) and return
    end

    # ここに到達している時点で、すべてのバリデーションに合格しているので、パスワード変更し、セッション再ログイン
    resource.update(password: new_password, password_confirmation: password_confirmation)
    bypass_sign_in(resource)
    redirect_to after_update_path_for(resource), notice: "パスワードを更新しました"
  end

  # 非公開プロフィールのエラー、更新処理
  def handle_profile_update
    if resource.update_without_password(
        account_update_params.except(:current_password, :password, :password_confirmation))
      redirect_to after_update_path_for(resource), notice: "プロフィールを更新しました"
    else
      store_form_data(attributes: account_update_params, 
        error_keys: [:last_name, :first_name, :email], form_type: :profile)
      redirect_to edit_user_registration_path(profile: true) and return
    end
  end

  # ユーザー入力情報とエラーメッセージをフラッシュに保存(パラメーター保持)
  def store_form_data(attributes:, error_keys:, form_type:, error_name: nil)
    # error_nameがnilなら"更新"を設定
    error_name ||= "更新"
    flash[:user_attributes] = attributes
    flash[:error_messages] = reorder_error_messages(resource, error_keys)
    flash[:form_type] = form_type
    flash[:error_name] = error_name
  end
end
