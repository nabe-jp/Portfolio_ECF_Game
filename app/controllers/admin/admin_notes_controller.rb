class Admin::AdminNotesController < Admin::ApplicationController
  # 入力フォームに表示する表記の読み込み(バリデーションに使用する絶対値を用いて表示)
  helper Admin::PlaceholdersHelper

  before_action :set_admin_note, only: [:edit, :update, :destroy, :reactivate]

  def index
    @admin_note = AdminNote.new(admin_note_attributes_from_session)

    # 並び順(初期表示は 'desc'＝新しい順)
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  
    # 削除済みの表示切り替え
    base_scope = params[:show_deleted] == 'true' ? AdminNote.all : AdminNote.undeleted_only
  
    # 固定は常に新しい順
    pinned_notes = base_scope.pinned.created_desc
  
    # 非固定は direction に応じて並び替え
    unpinned_notes = base_scope.unpinned.order(created_at: sort_direction)
  
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
      Form::DataStorageService.store(session: session, flash: flash, attributes: admin_note_params, 
        error_messages: @admin_note.errors.full_messages, error_name: '申し送りの作成', 
          key: :admin_note_attributes)
      redirect_to admin_notes_path
    end
  end

  def edit
    if session[:admin_note_attributes]
      @admin_note.assign_attributes(session[:admin_note_attributes])
      clear_admin_note_session
    end
  end

  def update
    if @admin_note.update(admin_note_params)
      redirect_to admin_notes_path, notice: "申し送りを更新しました。"
    else
      Form::DataStorageService.store(session: session, flash: flash, attributes: admin_note_params, 
        error_messages: @admin_note.errors.full_messages, error_name: '申し送りの更新', 
          key: :admin_note_attributes)
      redirect_to edit_admin_note_path(@admin_note)
    end
  end

  def destroy
    @admin_note.update(deleted_at: Time.current)
    redirect_to admin_notes_path, notice: "申し送りを削除しました。"
  end

  def reactivate
    @admin_note.update(deleted_at: nil)
    redirect_to admin_notes_path, notice: '申し送りを復元しました'
  end

  private

  def set_admin_note
    @admin_note = AdminNote.find(params[:id])
  end
  
  def admin_note_attributes_from_session
    data = session[:admin_note_attributes]
    clear_admin_note_session if data.present?
    data || {}
  end

  def clear_admin_note_session
    session.delete(:admin_note_attributes)
  end

  def admin_note_params
    params.require(:admin_note).permit(:title, :body, :is_pinned)
  end
end