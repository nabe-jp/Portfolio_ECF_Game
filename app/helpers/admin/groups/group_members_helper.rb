module Admin::Groups::GroupMembersHelper
  # paramsから必要なキー(group_id, :type, :page, :status)のみを許可し取得、それにメソッドの引数で渡された
  # パラメータをマージ(上書き)して管理画面のグループメンバー一覧ページのURLを生成して返すヘルパーメソッド
  def group_members_url_with(params_overrides)
    permitted = params.permit(:group_id, :type, :page, :status, :visibility, :direction)
    
    # 許可済みパラメータに引数の上書きパラメータをマージし、admin_group_members_pathのURL生成に渡す
    admin_group_members_path(permitted.merge(params_overrides))
  end
end