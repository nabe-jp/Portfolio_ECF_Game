module Admin::StatusHelper
  def status_label(record)
    return "-" if record.nil?
  
    # User用: is_deleted
    if record.is_a?(User) && record.respond_to?(:is_deleted)
      return content_tag(:span, "無効", class: "badge bg-secondary") if record.is_deleted
      return content_tag(:span, "有効", class: "badge bg-success")
    end
  
    # 削除済（User以外）
    if record.respond_to?(:is_deleted) && record.is_deleted
      return content_tag(:span, "削除済", class: "badge bg-danger")
    end
  
    # 固定
    if record.respond_to?(:is_pinned) && record.is_pinned
      return content_tag(:span, "固定", class: "badge bg-warning text-dark")
    end
  
    # 公開 / 非公開（投稿やコメントなど）
    if record.respond_to?(:is_public)
      return content_tag(:span, "公開", class: "badge bg-success") if record.is_public
      return content_tag(:span, "非公開", class: "badge bg-secondary")
    end
  
    # 最後に到達したら -
    "-"
  end
  

  def row_class(record)
    return "table-secondary" if record.respond_to?(:is_deleted) && record.is_deleted
    return "" # 通常行
  end
end