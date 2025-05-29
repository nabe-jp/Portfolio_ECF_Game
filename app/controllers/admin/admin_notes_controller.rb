class Admin::AdminNotesController < Admin::ApplicationController
  before_action :set_admin_note, only: [:edit, :update, :destroy, :reactivate]

  def index
    @admin_note = AdminNote.new(session.delete(:admin_note_attributes) || {})
  
    # 並び順(初期表示は 'desc'＝新しい順)
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
      store_form_data(
        attributes: admin_note_params, error_messages: @admin_note.errors.full_messages, error_name: "作成")
      redirect_to admin_notes_path
    end
  end

  def edit
    if session[:admin_note_attributes]
      @admin_note.assign_attributes(session[:admin_note_attributes])
      session.delete(:admin_note_attributes)
    end
  end

  def update
    if @admin_note.update(admin_note_params)
      redirect_to admin_notes_path, notice: "申し送りを更新しました。"
    else
      store_form_data(attributes: admin_note_params, error_messages: @admin_note.errors.full_messages)
      redirect_to edit_admin_note_path(@admin_note)
    end
  end

  def destroy
    @admin_note.update(deleted_at: Time.current)
    redirect_to admin_notes_path, notice: "申し送りを削除しました。"
  end

  def reactivate
    @admin_note.update(deleted_at: nil)
    redirect_to admin_notes_path, notice: 'お知らせを復元しました'
  end

  private

  def store_form_data(attributes:, error_messages:, error_name: nil)
    error_name ||= "更新"
    session[:admin_note_attributes] = attributes
    flash[:error_messages] = error_messages
    flash[:error_name] = error_name
  end

  def set_admin_note
    @admin_note = AdminNote.find(params[:id])
  end

  def admin_note_params
    params.require(:admin_note).permit(:title, :body, :is_pinned)
  end
end