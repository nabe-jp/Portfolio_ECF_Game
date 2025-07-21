class Public::Groups::GroupPostsController < Public::ApplicationController
  include Public::AuthorizeGroup

  # 入力フォームに表示する表記の読み込み(バリデーションに使用する絶対値を用いて表示)
  helper Public::PlaceholdersHelper

  # 読み込んだモジュール(AuthorizeGroup)のメソッドをviewで使用する為に必要
  helper_method :group_post_editor?
  helper_method :group_post_comment_editor?

  before_action :authenticate_user!
  before_action :authorize_group_member!, except: [:show]
  before_action :set_group_post, only: [:show, :edit, :update, :destroy]
  before_action :set_group_membership, only: [:create]
  before_action :authorize_group_post_editor!, only: [:edit, :update, :destroy]
  
  def index
    @group_posts = @group.group_posts.active_group_posts_for_members_desc.page(params[:page])
  end

  def show
    @group_post_comments = @group_post.group_post_comments
      .visible_top_level.includes(member: :user, replies: { member: :user }).page(params[:page]).per(20)
   
    if session[:group_post_comment_attributes]
      @group_post_comment = @group_post.group_post_comments.new(session[:group_post_comment_attributes])
      clear_group_post_comment_session
    else
      @group_post_comment = @group_post.group_post_comments.new
    end
  end

  def new
    @form_action_url = group_posts_path(@group)
    @form_method = :post
    @group_post = @group.group_posts.new(group_post_attributes_from_session)
  end

  def create
    @group_post = @group.group_posts.new(group_post_params)
    @group_post.member = @group_membership

    if @group_membership.nil?
      redirect_to group_path(@group), alert: '有効なメンバーシップが確認できなかったため、投稿できません'
      return
    end

    if @group_post.save
      @group.update_column(:last_posted_at, Time.current)
      redirect_to group_post_path(@group, @group_post), notice: '投稿を作成しました'
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: group_post_params, 
        error_messages: @group_post.errors.full_messages, error_name: '投稿', 
          key: :group_post_attributes)
      redirect_to new_group_post_path(@group)
    end
  end

  def edit
    @form_action_url = group_post_path(@group, @group_post)
    @form_method = :patch
    if session[:group_post_attributes]
      @group_post.assign_attributes(session[:group_post_attributes])
      clear_group_post_session
    end
  end

  def update
    if @group_post.update(group_post_params)
      redirect_to group_post_path(@group, @group_post), notice: '投稿が更新されました'
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: group_post_params, 
        error_messages: @group_post.errors.full_messages, error_name: '投稿の更新', 
          key: :group_post_attributes)
      redirect_to edit_group_post_path(@group, @group_post)
    end
  end

  def destroy
    # ユーザー自身かグループ管理者かの判定
    if @group_post.member.user == current_user
      deleted_reason = :self_deleted
    elsif group_moderator?
      deleted_reason = :removed_by_group_authority
    end

    begin
      Deleter::GroupPostDeleter.new(@group_post, deleted_by: current_user, 
        deleted_reason: deleted_reason).call
      redirect_to group_dashboard_path(@group), notice: '投稿を削除しました'
    rescue => e
      Rails.logger.error("GroupPost削除エラー: #{e.message}")
      redirect_to root_path, alert: '予期せぬエラーにより、投稿の削除が行えませんでした'
    end
  end

  private

  def set_group_post
    @group_post = @group.group_posts.active_group_post_for_members.find(params[:id])
  end

  def set_group_membership
    @group_membership = @group.group_memberships.active_members.find_by(user_id: current_user.id)
  end

  def group_post_attributes_from_session
    data = session[:group_post_attributes]
    clear_group_post_session if data.present?
    data || {}
  end

  def clear_group_post_session
    session.delete(:group_post_attributes)
  end
    
  def clear_group_post_comment_session
    session.delete(:group_post_comment_attributes)
  end
  
  def group_post_params
    params.require(:group_post).permit(:group_post_image, :title, :body, :visible_to_non_members)
  end
end