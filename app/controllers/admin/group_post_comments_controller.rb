class Admin::GroupPostCommentsController < Admin::ApplicationController
  
  def destroy

    begin
      Deleter::GroupPostCommentDeleter.call(@comment, deleted_by: current_user)
      redirect_to group_group_post_path(@comment.group_post.group, @comment.group_post),
      notice: "コメントを削除しました"
    rescue => e
      redirect_to root_path, alert: '予期せぬエラーにより、コメントの削除が行えませんでした。'
    end


  end
end
