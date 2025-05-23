class Admin::DashboardController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  
  def top
    @admin_notes = AdminNote.where(deleted_at: nil).order(created_at: :desc).limit(5)

    base_scope = Information.where(deleted_at: nil)
  
    pinned = base_scope.where(is_pinned: true).order(published_at: :desc)
    unpinned = base_scope.where(is_pinned: false).order(published_at: :asc)
  
    @informations = (pinned + unpinned).first(5)
  end
end
