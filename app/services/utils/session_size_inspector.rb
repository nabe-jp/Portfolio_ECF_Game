# セッションのサイズ調査に使用
# 呼び出し方：Utils::SessionSizeInspector.measure(session: session, data: attributes)
module Utils
  class SessionSizeInspector
    def self.measure(session:, data:)
      # 暗号化キーの生成
      key = Rails.application.key_generator.generate_key(
        Rails.application.secret_key_base,
        ActiveSupport::MessageEncryptor.key_len
      )
      encryptor = ActiveSupport::MessageEncryptor.new(key)

      # JSON変換後のデータサイズ（暗号化前）
      json_data = data.to_json
      raw_size = json_data.bytesize

      # 暗号化後のデータサイズ
      encrypted = encryptor.encrypt_and_sign(json_data)
      encrypted_size = encrypted.bytesize

      # ログ出力
      Rails.logger.debug("🔍 SessionSizeInspector: 暗号化前サイズ: #{raw_size} bytes")
      Rails.logger.debug("🔐 SessionSizeInspector: 暗号化後サイズ: #{encrypted_size} bytes")
      Rails.logger.debug("📦 SessionSizeInspector: セッション全体のキー: #{session.to_h.keys}")

      # 各キーのサイズ出力
      session_sizes = session.to_h.transform_values { |v| v.to_s.bytesize }
      Rails.logger.debug("🧩 SessionSizeInspector: セッション各キーのサイズ:")
      session_sizes.each do |k, size|
        Rails.logger.debug("  #{k.inspect} => #{size} bytes")
      end
    end
  end
end