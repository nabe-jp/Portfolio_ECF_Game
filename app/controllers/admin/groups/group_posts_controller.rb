class Admin::Groups::GroupPostsController < Admin::ApplicationController
  include Admin::Publishable

  before_action :set_group
  before_action :set_group_post, only: [:show, :destroy, :reactivate]

  def index
    @group_posts = @group.group_posts.where(is_deleted: false).order(created_at: :desc)
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトをにてグループ内投稿とグループ内投稿に紐づくものを論理削除
      Deleter::GroupPostsDeleter.new(@group_post, deleted_by: current_user, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_posts_path(@group), notice: "投稿を削除しました。"
    rescue => e
      Rails.logger.error("GroupPost削除エラー: #{e.message}")
      redirect_to admin_group_posts_path(@group), alert: '予期せぬエラーにより、投稿の削除が行えませんでした。'
    end
  end

  def reactivate
    begin
      Restorer::GroupPostRestorer.new(@group, @group_post).call
      redirect_to admin_group_post_path(@group, @group_post), notice: '投稿を復元しました'
    rescue => e
      Rails.logger.error("GroupPost復元エラー: #{e.message}")
      redirect_to admin_group_post_path(@group, @group_post), 
        alert: '予期せぬエラーにより、投稿の復元が行えませんでした。'
    end
  end

  # Publishable内で使用する、公開/非公開のために必要
  def set_resource_for_publication
    @resource = GroupPost.find(params[:id])
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_post
    @group_post = @group.group_posts.find(params[:id])
  end
end