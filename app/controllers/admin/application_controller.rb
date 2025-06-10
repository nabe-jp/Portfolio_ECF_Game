class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_action :authenticate_admin!

  # 一覧の絞り込みロジック
  include Admin::FilteredRecords

  # ステータスタグ
  helper Admin::StatusHelper

end