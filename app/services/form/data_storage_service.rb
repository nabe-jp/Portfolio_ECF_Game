module Form
  # フォームでの入力エラー時に使用する
  class DataStorageService
    # サイズを計測する際の上限値(テスト時2106でオーバーフローが発生したので少し余裕をもって設定)
    MAX_SESSION_BYTES = 2000

    # session、flashはコントローラー内部でのみアクセス可能な特殊オブジェクトなので引数で設定している
    # これによりsession[]、flash[]をサービス内で使用できるようになる
    def self.store(session:, flash:, attributes:, error_messages:, error_name:, key: :form_attributes)
      
      # Railsがsessionの値をCookieに書き出すときにエラーが発生するのでコントローラーなどでキャッチ出来ない
      json_data = attributes.to_json
      error_data = error_messages.to_json
      existing_session_size = session.to_json.bytesize
    
      total = json_data.bytesize + error_data.bytesize + existing_session_size
      Rails.logger.warn("セッション保存前 データサイズ(#{total}バイト)")
      if total > MAX_SESSION_BYTES
        Rails.logger.warn("セッション保存に失敗: データサイズ過大(#{total}バイト)")
        flash[:alert] = "入力内容が大きすぎた為、入力内容を保持できませんでした 入力内容を短くして再度お試しください"
        return
      end
      
      session[key] = attributes

      # 肥大化を防ぐため、他のフォーム用セッションデータを削除
      clear(session: session, except_key: key.to_s)

      flash[:error_messages] = error_messages
      flash[:error_name] = error_name
   end

    # フォーム関連セッションキーのうちexcept_keyを除いて削除する
    def self.clear(session:, except_key:)
      keys_to_delete = session.keys.select do |k|
        k.to_s.end_with?('_attributes') && k.to_s != except_key
      end

      keys_to_delete.each { |k| session.delete(k) }
    end
  end
end