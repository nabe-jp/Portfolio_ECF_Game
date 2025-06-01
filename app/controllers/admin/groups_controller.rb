class Admin::GroupsController < Admin::ApplicationController

  def show
  end

  def destroy
    group = Group.find(params[:id])

    begin
      # サービスオブジェクトを呼び出しグループとグループに紐づけて論理削除を行う
      Deleter::GroupDeleter.call(group, current_admin)
      redirect_to admin_groups_path, notice: "グループを削除しました"
    rescue => e
      redirect_to root_path, alert: '予期せぬエラーにより、グループの削除が行えませんでした。'
    end
  end
end
