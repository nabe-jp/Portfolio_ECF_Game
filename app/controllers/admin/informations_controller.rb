class Admin::InformationsController < Admin::ApplicationController
  # 入力フォームに表示する表記の読み込み(バリデーションに使用する絶対値を用いて表示)
  helper Admin::PlaceholdersHelper

  before_action :set_information, only: [:edit, :update, :destroy, :reactivate]

  def index
    @information = Information.new(information_attributes_from_session)

    # 並び替えの対象（デフォルト: published_at）
    sort_key = %w(published_at).include?(params[:sort_by]) ? params[:sort_by] : "created_at"

    # 並び順（デフォルト: desc）
    direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"

    # 削除済みの表示切り替え
    show_deleted = ActiveModel::Type::Boolean.new.cast(params[:show_deleted])
    base_scope = show_deleted ? Information.all : Information.undeleted_only

    # ソート順を適用し、固定・非固定で分けて結合
    @informations = sorted_informations(base_scope, sort_key, direction).page(params[:page]).per(10)
  end

  def create
    @information = Information.new(information_params)
    @information.admin_id = current_admin.id

    if @information.save
      redirect_to admin_informations_path, notice: "お知らせを作成しました。"
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: information_params, 
        error_messages: @information.errors.full_messages, error_name: 'お知らせの作成', 
          key: :information_attributes)
      redirect_to admin_informations_path
    end
  end

  def edit
    if session[:information_attributes]
      @information.assign_attributes(session[:information_attributes])
      clear_information_session
    end
  end

  def update
    if @information.update(information_params)
      redirect_to admin_informations_path, notice: "お知らせを更新しました。"
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: information_params, 
        error_messages: @information.errors.full_messages, error_name: 'お知らせの更新', 
          key: :information_attributes)
      redirect_to edit_admin_information_path(@information)
    end
  end 

  def destroy
    @information.update(deleted_at: Time.current)
    redirect_to admin_informations_path, notice: "お知らせを削除しました。"
  end

  def reactivate
    @information.update(deleted_at: nil)
    redirect_to admin_informations_path, notice: 'お知らせを復元しました'
  end

  private

  # 並び替え対象カラムのバリデーション
  def valid_sort_key(key)
    %w(posted_at published_at).include?(key) ? key : "published_at"
  end

  # 並び方向のバリデーション
  def valid_sort_direction(dir)
    %w(asc desc).include?(dir) ? dir : "desc"
  end

  # 並び替え実行(固定・非固定で分けて結合)
  def sorted_informations(scope, sort_key, direction)
    # 共通の並び順指定
    # 固定された投稿：sort_order で昇順
    pinned = scope.where(is_pinned: true).order(:sort_order).order(published_at: :desc).order(:id).to_a

    # 非固定投稿：任意のキー(投稿日など)でソート
    order_sql = Arel.sql("#{sort_key} #{direction}, id #{direction}")
    non_pinned = scope.where(is_pinned: false).order(order_sql).to_a

    # 配列結合 → paginate_arrayで戻す
    Kaminari.paginate_array(pinned + non_pinned)
  end

  def set_information
    @information = Information.find(params[:id])
  end
  
  def information_attributes_from_session
    data = session[:information_attributes]
    clear_information_session if data.present?
    data || {}
  end

  def clear_information_session
    session.delete(:information_attributes)
  end
  
  def information_params
    params.require(:information).permit(
      :title, :body, :published_at, :is_public, :is_pinned, :sort_order, :enable_sort_order)
  end
end