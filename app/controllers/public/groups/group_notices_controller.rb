class Public::Groups::GroupNoticesController < Public::ApplicationController
  include Public::AuthorizeGroup

  # 入力フォームに表示する表記の読み込み(バリデーションに使用する絶対値を用いて表示)
  helper Public::PlaceholdersHelper

  # 読み込んだモジュール(AuthorizeGroup)のメソッドをviewで使用する為に必要
  helper_method :group_moderator?

  before_action :authenticate_user!
  before_action :authorize_group_member!
  before_action :authorize_group_moderator!, only: [:edit, :update, :destroy]
  before_action :set_group_notice, only: [:show, :edit, :update, :destroy]
  before_action :set_current_user, only: [:create]

  def index
    @group_notices = @group.group_notices.active_group_notices.page(params[:page])
  end

  def show; end

  def new
    @form_url = group_notices_path(@group)
    @group_notice = @group.group_notices.new(group_notice_attributes_from_session)
  end

  def create
    @group_notice = @group.group_notices.build(group_notice_params)
    @group_notice.member = @group_membership

    if @group_notice.save
      redirect_to group_notices_path(@group), notice: "お知らせを作成しました。"
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: group_notice_params, 
        error_messages: @group_notice.errors.full_messages, error_name: 'お知らせの作成', 
          key: :group_notice_attributes)
      redirect_to new_group_notice_path(@group)
    end
  end

  def edit
    @form_url = group_notice_path(@group, @group_notice)
    if session[:group_notice_attributes]
      @group_notice.assign_attributes(session[:group_notice_attributes])
      clear_group_notice_session
    end
  end

  def update
    if @group_notice.update(group_notice_params)
      redirect_to group_notices_path(@group), notice: "お知らせを更新しました。"
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: group_notice_params, 
        error_messages: @group_notice.errors.full_messages, error_name: 'お知らせの更新', 
          key: :group_notice_attributes)
      redirect_to edit_group_notice_path(@group, @group_notice)
    end
  end

  def destroy
    begin
      Deleter::GroupNoticeDeleter.new(@group_notice, deleted_by: current_user, 
        deleted_reason: :removed_by_group_authority).call
      redirect_to group_notices_path(@group), notice: "お知らせを削除しました"
    rescue => e
      Rails.logger.error("GroupNotice削除エラー: #{e.message}")
      redirect_to group_notices_path(@group), alert: '予期せぬエラーにより、お知らせの削除が行えませんでした。'
    end
  end

  private

  def set_group_notice
    @group_notice = @group.group_notices.find(params[:id])
  end

  def set_current_user
    @group_membership = @group.group_memberships.find_by(user_id: current_user.id)
  end

  def group_notice_attributes_from_session
    data = session[:group_notice_attributes]
    clear_group_notice_session if data.present?
    data || {}
  end

  def clear_group_notice_session
    session.delete(:group_notice_attributes)
  end

  def group_notice_params
    params.require(:group_notice).permit(:title, :body, :is_pinned)
  end
end
