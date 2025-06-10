class Public::GroupsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_group, only: 
    [:show, :edit, :update, :destroy, :join, :leave, :hide_from_owner, :show_by_owner, :dashboard]
  before_action :authorize_group_member!, only: [:dashboard]
  before_action :authorize_group_manager!,only: [:edit, :update, :destroy, :hide_from_owner, :show_by_owner]

  def index
    @groups = Group.active_groups_desc.page(params[:page])
  end

  def show
    if user_signed_in? && @group.group_memberships.exists?(user_id: current_user.id)
      redirect_to group_dashboard_path(@group) and return
    else
      # 非メンバー用の公開投稿のみ取得 + ページネーション
      @public_posts = @group.group_posts.active_group_posts_for_all_desc.page(params[:page])
    end
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
      Deleter::GroupDeleter.newl(@group, current_user).call
      redirect_to my_groups_path, notice: "グループを削除しました"
    rescue => e
      Rails.logger.error("コメント削除エラー: #{e.message}")
      redirect_to my_groups_path, alert: '予期せぬエラーにより、グループの削除が行えませんでした。'
    end
  end

  def join
    if current_user && !@group.group_memberships.exists?(user_id: current_user.id)
      if @group.group_memberships.create(user: current_user)
        flash[:notice] = "グループに参加しました"
      else
        flash[:alert] = "参加に失敗しました"
      end
    else
      flash[:alert] = "ログインしてください"
    end
    redirect_to group_path(@group)
  end

  def leave
    membership = @group.group_memberships.find_by(user_id: current_user.id)
    if membership
      membership.destroy
      flash[:notice] = "グループを退出しました"
    else
      flash[:alert] = "参加していません"
    end
    redirect_to group_path(@group)
  end

  def my_groups
    @owned_groups = current_user
      .owned_groups.merge(Group.active_groups_desc).page(params[:owned_page]).per(6)

    @joined_groups = current_user
      .joined_groups.where.not(id: current_user.owned_groups.pluck(:id))
        .merge(Groupactive_groups_desc).page(params[:joined_page]).per(6)
  end

  private

  def set_group
    @group = Group.find_by!(slug: params[:slug])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "指定されたグループが見つかりませんでした"
  end

  # 作成者か確認
  def authorize_group_manager!
    unless @group.owner_id == current_user.id
      redirect_to group_path(@group), alert: "管理者のみ実行できる操作です。"
    end
  end

  # グループメンバーか確認
  def authorize_group_member!
    unless @group.members.include?(current_user)
      redirect_to group_path(@group), alert: "このグループのメンバーのみアクセスできます。"
    end
  end

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
    params.require(:group).permit(:group_image, :name, :description, :slug, :is_public, tag_list: [])
  end
end