module ErrorsHelper
  # 指定された属性に関するエラーメッセージを末尾に回す
  def reorder_error_messages(resource, deferred_attrs = [])
    return [] unless resource&.errors&.any?

    # 指定された属性に関するエラーメッセージを抽出
    deferred_messages = 
      deferred_attrs.flat_map do |attr|
        resource.errors.full_messages_for(attr)
      end

    # 残りのメッセージを先に
    other_messages = resource.errors.full_messages - deferred_messages
    other_messages + deferred_messages
  end
end