module Admin::StatusHelper
  def status_label(record)
    return "-" if record.nil?
  
    # User用: user_status
    if record.is_a?(User) && record.respond_to?(:user_status)
      if record.respond_to?(:restored_pending) && record.restored_pending
        return content_tag(:span, "復元後非アクティブ", class: "badge badge-warning")
      end

      if record.user_status == "active"
        return content_tag(:span, "有効", class: "badge badge-success")
      else
        return content_tag(:span, "無効", class: "badge badge-danger")
      end
    end

    # 公開ステータスに使用しているため、有効を公開にしている
    # GroupMembership用: member_status
    if record.is_a?(GroupMembership) && record.respond_to?(:member_status)

      if record.member_status == "active"
        if (record.respond_to?(:is_public) && !record.is_public) || 
          (record.respond_to?(:hidden_on_parent_restore) && record.hidden_on_parent_restore)
          return content_tag(:span, "非公開", class: "badge badge-secondary")
        end

        return content_tag(:span, "公開", class: "badge badge-success")
      else
        return content_tag(:span, "無効", class: "badge badge-danger")
      end
    end

    # 削除済（User以外）
    if !record.is_a?(User) && record.respond_to?(:is_deleted) && record.is_deleted
      return content_tag(:span, "削除済", class: "badge badge-danger")
    end
  
    # 公開 / 非公開
    if !record.is_a?(User) && record.respond_to?(:is_public)
      return content_tag(:span, "公開", class: "badge badge-success") if 
        record.is_public && !record.hidden_on_parent_restore
      return content_tag(:span, "非公開", class: "badge badge-secondary")
    end
  
    # 最後に到達したら -
    "-"
  end
  
  # グループ内投稿の公開範囲
  def non_member_visibility_label(record)
    return "-" if record.nil? || !record.respond_to?(:visible_to_non_members)

    if record.visible_to_non_members
      content_tag(:span, "外部公開", class: "badge bg-primary")
    else
      content_tag(:span, "メンバー限定", class: "badge bg-dark text-white")
    end
  end

  # 連鎖削除されたものが親の復元により復元される、そのステータスを表示する際に使用
  def hidden_on_parent_restore_label(record)
    return "-" unless record.respond_to?(:hidden_on_parent_restore)

    if record.hidden_on_parent_restore
      content_tag(:span, "親の復元により非公開", class: "badge badge-warning")
    else
      "-"
    end
  end

  def row_class(record)
    return "table-secondary" if !record.is_a?(User) && record.respond_to?(:is_deleted) && 
      record.is_deleted

    return "table-secondary" if record.is_a?(GroupMembership) && record.respond_to?(:member_status) && 
      (record.member_status_inactive? || record.member_status_kicked? || record.member_status_suspended?)

    return "" # 通常行
  end
end