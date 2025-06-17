module Admin::FilterableStatus
  extend ActiveSupport::Concern

  included do
    before_action :set_filter_status, only: [:index]
  end

  private

  def set_filter_status
    # パラメータをbooleanに変換して状態を保持(パラメーターがない場合はfalse)
    @show_non_public = ActiveModel::Type::Boolean.new.cast(params[:show_non_public])
    @show_deleted     = ActiveModel::Type::Boolean.new.cast(params[:show_deleted])
    @show_all         = params[:show] == "all"
  end
end