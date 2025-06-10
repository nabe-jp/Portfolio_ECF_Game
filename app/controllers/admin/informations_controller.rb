class Admin::InformationsController < Admin::ApplicationController

  before_action :set_information, only: [:edit, :update, :destroy, :reactivate]

  def index
    @information = Information.new(session.delete(:information_attributes) || {})

    # 並び替えの対象（デフォルト: posted_at）
    sort_key = %w(posted_at published_at).include?(params[:sort_by]) ? params[:sort_by] : "created_at"

    # 並び順（デフォルト: desc）
    direction = %w(asc desc).include?(params[:direction]) ? params[:direction] : "desc"

    # 削除済みの表示切り替え
    show_deleted = ActiveModel::Type::Boolean.new.cast(params[:show_deleted])
    base_scope = show_deleted ? Information.all : Information.where(deleted_at: nil)

    # ソート順を適用し、固定・非固定で分けて結合
    @informations = sorted_informations(base_scope, sort_key, direction).page(params[:page]).per(10)
  end

  def create
    @information = Information.new(information_params)
    @information.admin_id = current_admin.id

    if @information.save
      redirect_to admin_informations_path, notice: "お知らせを作成しました。"
    else
      store_form_data(attributes: information_params, 
        error_messages: @information.errors.full_messages, error_name: "作成")
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
      store_form_data(attributes: information_params,
        error_messages: @information.errors.full_messages)
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
    params.require(:information).permit(
      :title, :body, :published_at, :is_public, :is_pinned, :sort_order, :enable_sort_order)
  end
end