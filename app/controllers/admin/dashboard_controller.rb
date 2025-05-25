class Admin::DashboardController < Admin::ApplicationController
  
  def top
    # 申し送り(AdminNote)
    note_base = AdminNote.where(deleted_at: nil)

    pinned_notes = note_base.where(is_pinned: true).order(created_at: :desc)
    unpinned_notes = note_base.where(is_pinned: false).order(created_at: :desc)

    @admin_notes = (pinned_notes + unpinned_notes).first(5)

    # お知らせ(Information)、非公開は非表示、固定と非固定で分けて表示(公開日順に新しいものが上)
    base_scope = Information.where(deleted_at: nil, is_public: true)

    pinned_informations = base_scope.where(is_pinned: true).order(:sort_order, published_at: :desc)
    unpinned_informations = base_scope.where(is_pinned: false).order(published_at: :desc)

    @informations = (pinned_informations + unpinned_informations).first(5)

  end
end
