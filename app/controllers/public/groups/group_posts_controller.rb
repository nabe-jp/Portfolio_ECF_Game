class Public::Groups::GroupPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :authorize_group_member!, except: [:show]
  before_action :set_group_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_group_operator!, only: [:edit, :update, :destroy]
  
  def show
    @group_post_comments= @group_post.group_post_comments.active_comment
      .includes(:user, :parent_comment).order(created_at: :desc).page(params[:page]).per(20)
   
    if session[:group_post_comment_attributes]
      @group_post_comment = @group_post.group_post_comments.new(session[:group_post_comment_attributes])
      session[:group_post_comment_attributes] = nil
    else
      @group_post_comment = @group_post.group_post_comments.new
    end
  end

  def new
    @url = group_posts_path(@group)
    @verd = :post
    @group_post = @group.group_posts.new(group_post_attributes_from_session)
  end

  def create
    @group_post = current_user.group_posts.new(group_post_params)
    @group_post.group = @group

    if @group_post.save
      @group.update_column(:last_posted_at, Time.current)
      session[:group_post_attributes] = nil
      redirect_to dashboard_group_path(@group), notice: '投稿を作成しました。'
    else
      store_form_data(attributes: group_post_params, error_messages: @group_post.errors.full_messages, error_name: "投稿")
      redirect_to new_group_post_path(@group)
    end
  end

  def edit
    @url = group_post_path(@group.id)
    @verd = :patch
    if session[:group_post_attributes]
      @group_post.assign_attributes(session[:group_post_attributes])
      session.delete(:group_post_attributes)
    end
  end

  def update
    if @group_post.update(group_post_params)
      session.delete(:group_post_attributes)
      redirect_to group_post_path(@group, @group_post), notice: '投稿が更新されました。'
    else
      store_form_data(attributes: group_post_params, error_messages: @group_post.errors.full_messages)
      redirect_to edit_group_post_path(@group, @group_post)
    end
  end

  def destroy
    begin
      Deleter::GroupPostDeleter.call(@group_post, deleted_by: current_user)
      redirect_to dashboard_group_path(@group), notice: '投稿を削除しました。'
    rescue => e
      Rails.logger.error("GroupPost削除エラー: #{e.message}")
      redirect_to root_path, alert: '予期せぬエラーにより、投稿の削除が行えませんでした。'
    end
  end

  private

  def set_group
    @group = Group.find_by!(slug: params[:group_slug])
  end

  def set_group_post
    @group_post = @group.group_posts.find(params[:id])
  end

  def authorize_group_member!
    unless @group.members.include?(current_user)
      redirect_to group_path(@group), alert: 'このグループのメンバーのみアクセスできます。'
    end
  end

  def authorize_group_operator!
    unless @group_post.user == current_user || @group.owned_by?(current_user)
      redirect_to dashboard_group_path(@group), alert: '権限がありません。'
    end
  end

  def group_post_attributes_from_session
    session[:group_post_attributes] || {}
  end

  def store_form_data(attributes:, error_messages:, error_name: nil)
    error_name ||= "更新"
    session[:group_post_attributes] = attributes.except("group_post_image")
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end
  
  def group_post_params
    params.require(:group_post).permit(:group_post_image, :title, :body, :visible_to_non_members)
  end
end