class Public::RegistrationsController < Devise::RegistrationsController
  # エラーメッセージの並べ替えに使用するヘルパーメソッドの読み込み
  include ErrorsHelper

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

  def edit
    # エラー時にはフラッシュが入力を保持し、入力情報がない場合(初回表示時)は現在のユーザー情報をそのまま利用
    unless params[:password]
      if flash[:user_attributes]
        build_resource(flash[:user_attributes])
      else
        build_resource(resource.attributes)
      end
    end

    # 受け取った情報をもとに表示フォームを変更
    if params[:profile]
      @profile_edit = true
    elsif params[:password]
      @password_edit = true
    end
    # 親クラスを呼び出し処理を引き継ぐ
    super
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
      store_form_data(attributes: sign_up_params, error_keys: [:email, :password], form_type: :sign_up)
      redirect_to new_user_registration_path
    end
  end

  def update
    # 現在ログインしているユーザーを取得し、それを基にデータベースからユーザーを取得
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    
    # パスワード変更
    if params[:user][:form_type] == "password"
      # 新しいパスワードが空か判定
      if params[:user][:new_password].blank?
        resource.errors.add(:new_password, "は必須です")
      # 新しいパスワードが現在のパスワードと一致するか判定
      elsif resource.valid_password?(params[:user][:new_password])
        resource.errors.add(:new_password, "は現在のパスワードと同じです")
      # 新しいパスワードの長さが正しいか判定
      elsif params[:user][:new_password].length < Devise.password_length.first || 
            params[:user][:new_password].length > Devise.password_length.last
        resource.errors.add(:new_password, "は #{Devise.password_length.first}文字以上、#{Devise.password_length.last}文字以内でなければなりません")
      end

      # パスワード確認用が空か判定
      if params[:user][:password_confirmation].blank?
        resource.errors.add(:password_confirmation, "は必須です")
      # 新しいパスワードと確認用パスワードが一致しているか判定
      elsif params[:user][:new_password] != params[:user][:password_confirmation]
        resource.errors.add(:password_confirmation, "と 新しいパスワード が一致しません")
      end

      # 現在のパスワードが空か判定
      if params[:user][:current_password].blank?
        resource.errors.add(:current_password, "は必須です")
      # 現在のパスワードが正しい空か判定
      elsif !resource.valid_password?(params[:user][:current_password])
          resource.errors.add(:current_password, "が間違っています")
      end
  
      # エラーがあれば、エラーメッセージをフラッシュに保存してリダイレクト
      if resource.errors.any?
        flash[:error_messages] = resource.errors.full_messages
        redirect_to edit_user_registration_path(password: true)
        return
      end

    # プロフィール更新
    elsif params[:user][:form_type] == "profile"
      if resource.update_without_password(account_update_params.except(:current_password, 
          :password, :password_confirmation))
        redirect_to after_update_path_for(resource), notice: "プロフィールを更新しました"
      else
        store_form_data(attributes: account_update_params,
                       error_keys: [:last_name, :first_name, :email],
                        form_type: :profile)
        redirect_to edit_user_registration_path(profile: true)
      end
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

  # ユーザー入力情報とエラーメッセージをフラッシュに保存
  def store_form_data(attributes:, error_keys:, form_type:)
    flash[:user_attributes] = attributes
    flash[:error_messages] = reorder_error_messages(resource, error_keys)
    flash[:form_type] = form_type
  end
end
