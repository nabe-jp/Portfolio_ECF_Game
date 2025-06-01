class Admin::GroupPostsController < Admin::ApplicationController

  def index
  end

  def show
  end

  def destroy


    begin
      # サービスオブジェクトをにてグループ内投稿とグループ内投稿に紐づくものを論理削除
      Deleter::GroupPostsDeleter.call(group, current_user)
    rescue => e
      Rails.logger.error("UserPost削除エラー: #{e.message}")
      redirect_to root_path, alert: '予期せぬエラーにより、投稿の削除が行えませんでした。'
    end
  end
end
