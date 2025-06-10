class Public::Groups::GroupNoticesController < Public::ApplicationController
  include ::Public::Concerns::AuthorizeGroup

  before_action :authenticate_user!
  before_action :authorize_group_member!
  before_action :authorize_group_moderator!, only: [:edit, :update, :destroy]
  before_action :set_group_notice, only: [:show, :edit, :update, :destroy]
  before_action :set_current_user, only: [:create]

  def index
    @notices = @group.group_notices.active_group_info.page(params[:page]).per(10)
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
      session[:group_notice_attributes] = nil
      redirect_to group_notices_path(@group), notice: "お知らせを作成しました。"
    else
      store_form_data(attributes: group_notice_params, 
        error_messages: @group_notice.errors.full_messages, error_name: "お知らせの作成")
      redirect_to new_group_notice_path(@group)
    end
  end

  def edit
    @form_url = group_notice_path(@group, @group_notice)
    if session[:group_notice_attributes]
      @group_notice.assign_attributes(session[:group_notice_attributes])
      session.delete(:group_notice_attributes)
    end
  end

  def update
    if @group_notice.update(group_notice_params)
      session.delete(:group_notice_attributes)
      redirect_to group_notices_path(@group), notice: "お知らせを更新しました。"
    else
      store_form_data(attributes: group_notice_params, error_messages: @group_notice.errors.full_messages)
      redirect_to edit_group_notice_path(@group, @group_notice)
    end
  end

  def destroy
    begin
      Deleter::GroupNoticeDeleter.call(@group_notice, deleted_by: current_user)
      redirect_to group_notices_path(@group),
      notice: "お知らせを削除しました"
    rescue => e
      Rails.logger.error("お知らせ削除エラー: #{e.message}")
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
    session[:group_notice_attributes] || {}
  end

  def store_form_data(attributes:, error_messages:, error_name: nil)
    error_name ||= "お知らせの更新"
    session[:group_notice_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end

  def group_notice_params
    params.require(:group_notice).permit(:title, :body, :is_pinned)
  end
end
