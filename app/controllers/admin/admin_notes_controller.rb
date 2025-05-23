class Admin::AdminNotesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_admin_note, only: [:edit, :update, :destroy]

  def index
    @admin_note = AdminNote.new
  
    # 並び順（初期表示は 'desc'＝新しい順）
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  
    # 削除済みの表示切り替え
    base_scope = params[:show_deleted] == 'true' ? AdminNote.all : AdminNote.active
  
    # 固定は常に新しい順
    pinned_notes = base_scope.where(is_pinned: true).order(created_at: :desc).to_a
  
    # 非固定は direction に応じて並び替え
    unpinned_notes = base_scope.where(is_pinned: false).order(created_at: sort_direction).to_a
  
    # 上に固定、下に非固定を結合
    all_notes = pinned_notes + unpinned_notes
    @admin_notes = Kaminari.paginate_array(all_notes).page(params[:page]).per(10)
  end

  def create
    @admin_note = AdminNote.new(admin_note_params)
    @admin_note.admin_id = current_admin.id

    if @admin_note.save
      redirect_to admin_notes_path, notice: "申し送りを作成しました。"
    else
      @admin_notes = AdminNote.where(deleted_at: nil).order(created_at: :desc)
      flash.now[:alert] = "作成に失敗しました。"
      render :index, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @admin_note.update(admin_note_params)
      redirect_to admin_notes_path, notice: "申し送りを更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @admin_note.update(deleted_at: Time.current)
    redirect_to admin_notes_path, notice: "申し送りを削除しました。"
  end

  private

  def set_admin_note
    @admin_note = AdminNote.find(params[:id])
  end

  def admin_note_params
    params.require(:admin_note).permit(:title, :body, :is_pinned)
  end
end
