class Admin::DashboardController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  
  def top
    @admin_notes = AdminNote.order(created_at: :desc).limit(5)
    @informations = Information.order(published_at: :desc).limit(5)
  end
end
