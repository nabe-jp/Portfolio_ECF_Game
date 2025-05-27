class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_group_member!, only: [:dashboard]
  before_action :authorize_group_owner!, only: [:edit, :update, :destroy, :hide, :publish]
  before_action :set_group, only: [:show, :edit, :update, :destroy, :hide, :publish, :dashboard]

  def index
    @groups = Group.where(is_public: true).order(created_at: :desc)
  end

  def show; end

  def new
    @group = Group.new
  end

  def create
    # オーナーに現在のログインユーザーを設定
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      redirect_to group_path(@group), notice: "グループを作成しました"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @group.update(group_params)
      redirect_to public_group_path(@group), notice: "グループを更新しました"
    else
      render :edit
    end
  end

  def destroy
    begin
      # サービスオブジェクトをにてグループとグループに紐づくものを論理削除
      Deleter::GroupDeleter.new(group, current_user).call
      redirect_to public_groups_path, notice: "グループを削除しました"
    rescue => e
      redirect_to root_path, alert: '予期せぬエラーにより、グループの削除が行えませんでした。'
    end
  end

  def hide_from_owner
    @group.update(is_public: false)
    redirect_to public_group_path(@group), notice: "グループを非公開にしました"
  end
  
  def show_by_owner
    @group.update(is_public: true)
    redirect_to public_group_path(@group), notice: "グループを公開しました"
  end

  def my_groups
    @groups = current_user.joined_groups.order(created_at: :desc)
  end

  def dashboard
    @group_posts    = @group.group_posts.where(is_deleted: false).order(created_at: :desc)
    @group_events   = @group.group_events.where(is_deleted: false).order(start_time: :asc)
    @group_notices  = @group.group_notices.where(is_deleted: false).order(created_at: :desc)
    @members        = @group.members
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  # 作成者か確認
  def authorize_group_owner!
    unless @group.owner_id == current_user.id
      redirect_to public_group_path(@group), alert: "この操作は許可されていません。"
    end
  end

  # グループメンバーか確認
  def authorize_group_member!
    unless @group.members.include?(current_user)
      redirect_to public_group_path(@group), alert: "このグループのメンバーのみアクセスできます。"
    end
  end

  def group_params
    params.require(:group).permit(:group_image, :name, :description, :slug, :is_public, tag_list: [])
  end
end