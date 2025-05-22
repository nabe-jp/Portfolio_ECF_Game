class Admin::AdminNotesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :set_admin_note, only: [:edit, :update]

  def new
    @admin_note = AdminNote.new
  end

  def create
    @admin_note = AdminNote.new(admin_note_params)
    @admin_note.admin = current_admin
    if @admin_note.save
      redirect_to admin_root_path, notice: "申し送りを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @admin_note = AdminNote.find(params[:id])
  end

  def update
    @admin_note = AdminNote.find(params[:id])
    if @admin_note.update(admin_note_params)
      redirect_to admin_root_path, notice: "申し送りを更新しました。"
    else
      render :edit
    end
  end

  private

  def set_admin_note
    @admin_note = AdminNote.find(params[:id])
  end

  def admin_note_params
    params.require(:admin_note).permit(:title, :body)
  end
end
