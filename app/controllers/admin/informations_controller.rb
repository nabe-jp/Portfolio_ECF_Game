class Admin::InformationsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_information, only: [:edit, :update, :destroy, :restore]

  def index
    @information = Information.new

    # デフォルトで 'desc'（新しい順）
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  
    base_scope = params[:show_deleted] == 'true' ? Information.all : Information.active
  
    # 固定は常に新しい順で上に
    pinned_infos = base_scope.where(is_pinned: true).order(created_at: :desc).to_a
  
    # 非固定は direction に応じて切り替え（created_at でソート）
    unpinned_infos = base_scope.where(is_pinned: false).order(created_at: sort_direction).to_a
  
    # 結合してページネーション
    all_infos = pinned_infos + unpinned_infos
    @informations = Kaminari.paginate_array(all_infos).page(params[:page]).per(10)
  end

  def create
    @information = Information.new(information_params)
    @information.admin_id = current_admin.id
    if @information.save
      redirect_to admin_informations_path, notice: "お知らせを作成しました。"
    else
      @informations = Information.where(deleted_at: nil).order(is_pinned: :desc, published_at: :desc)
      flash.now[:alert] = "作成に失敗しました。"
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @information = Information.find(params[:id])
    if @information.update(information_params)
      redirect_to admin_informations_path, notice: "お知らせを更新しました。"
    else
      render :edit
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

  def set_information
    @information = Information.find(params[:id])
  end

  def information_params
    params.require(:information).permit(:title, :body, :published_at, :visible, :is_pinned, :admin_id)
  end
end
