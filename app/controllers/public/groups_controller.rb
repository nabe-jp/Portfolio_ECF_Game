class Public::GroupsController < ApplicationController
  include Public::AuthorizeGroup
  
  # 読み込んだモジュールのメソッドをviewで使用する為に必要
  helper_method :group_owner?, :group_member?

  # 読み込んだモジュールの自動アクションを除外
  skip_before_action :set_group, only: [:index, :new, :create, :my_groups] 
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_group_moderator!,only: [:edit, :update]
  before_action :authorize_group_owner!,only: [:confirm_destroy, :destroy]

  def index
    @groups = Group.active_groups_desc.page(params[:page])
  end

  def show
    if user_signed_in?
      membership = @group.active_group_memberships.find_by(user_id: current_user.id)
  
      if membership.nil?
        redirect_to group_dashboard_path(@group) and return
      end
    end

    # 非メンバー用の公開投稿のみ取得 + ページネーション
    @public_posts = @group.group_posts.active_group_posts_for_all_desc.page(params[:page])
  end

  def new
    @group = Group.new(group_attributes_from_session)
  end
  
  def create
    session[:group_attributes] = nil
    # オーナーに現在のログインユーザーを設定
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      redirect_to group_path(@group), notice: "グループを作成しました"
    else
      store_form_data(attributes: group_params, 
        error_messages: @group.errors.full_messages, error_name: "グループ作成")
      redirect_to new_group_path
    end
  end

  def edit
    if session[:group_attributes]
      @group.assign_attributes(session[:group_attributes])
      session.delete(:group_attributes)
    end
  end

  def update
    if @group.update(group_params)
      session[:group_attributes] = nil
      redirect_to group_path(@group), notice: "グループを更新しました"
    else
      store_form_data(attributes: group_params, 
        error_messages: @group.errors.full_messages, error_name: "グループ更新")
      redirect_to edit_group_path(@group)
    end
  end

  def destroy
    begin
      # サービスオブジェクトをにてグループとグループに紐づくものを論理削除
      Deleter::GroupDeleter.new(@group, deleted_by: current_user, 
        deleted_reason: :removed_by_group_authority).call
      redirect_to my_groups_path, notice: "グループを削除しました"
    rescue => e
      Rails.logger.error("Group削除エラー: #{e.message}")
      redirect_to group_dashboard_path(@group), alert: '予期せぬエラーにより、グループの削除が行えませんでした。'
    end
  end

  def my_groups
    @owned_groups = current_user
      .owned_groups.merge(Group.active_groups_desc).page(params[:owned_page]).per(6)

    @joined_groups = current_user
      .active_joined_groups.where.not(id: current_user.owned_groups.pluck(:id))
        .merge(Group.active_groups_desc).page(params[:joined_page]).per(6)
  end

   # 削除確認画面
   def confirm_destroy; end

  private
  
  def group_attributes_from_session
    session[:group_attributes] || {}
  end
  
  def store_form_data(attributes:, error_messages:, error_name: nil)
    error_name ||= "更新"
    session[:group_attributes] = attributes.except("group_image")
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end

  def group_params
    params.require(:group).permit(:group_image, :name, :description, :slug, tag_list: [])
  end
end