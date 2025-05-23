class Admin::InformationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_information, only: [:edit, :update, :destroy, :restore]

  def index
    @information = Information.new(session.delete(:information_attributes) || {})

    # 並び順 (初期表示は 'desc'＝新しい順)
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'

    base_scope = params[:show_deleted] == 'true' ? Information.all : Information.active

    pinned_infos   = base_scope.where(is_pinned: true).order(created_at: :desc).to_a
    unpinned_infos = base_scope.where(is_pinned: false).order(created_at: sort_direction).to_a

    all_infos = pinned_infos + unpinned_infos
    @informations = Kaminari.paginate_array(all_infos).page(params[:page]).per(10)
  end

  def create
    @information = Information.new(information_params)
    @information.admin_id = current_admin.id

    if @information.save
      redirect_to admin_informations_path, notice: "お知らせを作成しました。"
    else
      store_form_data(
        attributes: information_params,
        error_messages: @information.errors.full_messages,
        error_name: "作成"
      )
      redirect_to admin_informations_path
    end
  end

  def edit
    if (attrs = session.delete(:information_attributes))
      @information.assign_attributes(attrs)
    end
  end

  def update
    if @information.update(information_params)
      redirect_to admin_informations_path, notice: "お知らせを更新しました。"
    else
      store_form_data(
        attributes: information_params,
        error_messages: @information.errors.full_messages
      )
      redirect_to edit_admin_information_path(@information)
    end
  end

  def destroy
    @information.update(deleted_at: Time.current)
    redirect_to admin_informations_path, notice: "お知らせを削除しました。"
  end

  def restore
    @information.update(deleted_at: nil)
    redirect_to admin_informations_path, notice: 'お知らせを復元しました'
  end

  private

  def store_form_data(attributes:, error_messages:, error_name: nil)
    error_name ||= "更新"
    session[:information_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end

  def set_information
    @information = Information.find(params[:id])
  end

  def information_params
    params.require(:information).permit(:title, :body, :published_at, :visible, :is_pinned)
  end
end