class Public::GroupPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_group_member!
  before_action :authorize_editor!, only: [:edit, :update, :destroy]
  before_action :set_group
  before_action :set_group_post, only: [:show, :edit, :update, :destroy]

  def new
    @group_post = @group.group_posts.new
  end

  def create
    @group_post = @group.group_posts.build(group_post_params)
    @group_post.user = current_user

    if @group_post.save
      redirect_to dashboard_group_path(@group), notice: '投稿を作成しました。'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @group_post.user != current_user
      redirect_to root_path, alert: "編集権限がありません"
    elsif @group_post.update(group_post_params)
      redirect_to public_group_post_path(@group, @group_post), notice: "投稿が更新されました"
    else
      render :edit
    end
  end

  def destroy
    if @group_post.user == current_user || @group.owner == current_user
      begin
        # サービスオブジェクトをにてグループ内投稿とグループ内投稿に紐づくものを論理削除
        Deleter::GroupPostDeleter.new(group, current_user).call
        redirect_to public_group_path(@group), notice: "投稿を削除しました"
      rescue => e
        redirect_to root_path, alert: '予期せぬエラーにより、投稿の削除が行えませんでした。'
      end
    else
      redirect_to root_path, alert: "削除権限がありません"
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_post
    @group_post = @group.group_posts.find(params[:id])
  end

  def group_post_params
    params.require(:group_post).permit(:title, :body, :group_post_image, :is_public, tag_list: [])
  end

  def authorize_group_member!
    unless @group.members.include?(current_user)
      redirect_to public_group_path(@group), alert: "このグループのメンバーのみアクセスできます。"
    end
  end

  def authorize_editor!
    unless current_user == @group_post.user || current_user == @group.owner
      redirect_to group_post_path(@group, @group_post), alert: "編集・削除する権限がありません。"
    end
  end
end