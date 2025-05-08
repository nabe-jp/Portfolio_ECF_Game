module Public::SessionsHelper
  
  # パスワードの最小文字数を表示するためのヘルパーメソッド
  def minimum_password_length_message(minimum_length)
    if minimum_length.nil? || minimum_length.to_s.strip.empty?    # 空、nilの場合は初期値を設定し管理者に通知
      minimum_length = 6                                          # 初期値の設定

      unless session[:password_notification_sent]                 # セッションに通知送信済みかどうかを確認
        send_admin_notification                                   # 管理者に通知
        session[:password_notification_sent] = true               # 通知済みフラグをセッションに記録
      end
    end
    message = "#{minimum_length}文字以上"
    return message
  end

  private

  # 管理者に通知を送信するメソッド
  def send_admin_notification
    # 未実装、エラーになるのでコメント化
    # AdminMailer.password_length_error_notification.deliver_now
  end
end
