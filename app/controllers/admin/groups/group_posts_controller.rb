class Admin::Groups::GroupPostsController < Admin::ApplicationController
  include Admin::Publishable
  include Admin::FilterableStatus

  before_action :set_group
  before_action :set_group_post, only: [:show, :destroy, :reactivate]

  def index
    @group_posts = filtered_records(@group.group_posts).order(*sort_order).page(params[:page])
  end

  def show; end

  def destroy
    begin
      # サービスオブジェクトをにてグループ内投稿とグループ内投稿に紐づくものを論理削除
      Deleter::GroupPostDeleter.new(@group_post, deleted_by: current_admin, 
        deleted_reason: :removed_by_admin).call
      redirect_to admin_group_post_path(@group.id, @group_post), notice: "投稿を削除しました"
    rescue => e
      Rails.logger.error("GroupPost削除エラー: #{e.message}")
      redirect_to admin_group_post_path(@group.id, @group_post), 
        alert: '予期せぬエラーにより、投稿の削除が行えませんでした'
    end
  end

  def reactivate
    begin
      Restorer::GroupPostRestorer.new(@group_post).call
      redirect_to admin_group_post_path(@group.id, @group_post), notice: '投稿を復元しました'
    rescue => e
      Rails.logger.error("GroupPost復元エラー: #{e.message}")
      flash[:alert] = e.message.presence || '予期せぬエラーにより、コメントの削除が行えませんでした'
      redirect_to admin_group_post_path(@group.id, @group_post)
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