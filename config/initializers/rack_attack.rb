# frozen_string_literal: true

# DB書き込み系エンドポイントへの過剰リクエストを防止するための制限
# スパム投稿・DoS攻撃によるサービス負荷軽減を目的とする
class Rack::Attack
  
  # 共通設定
  PERIOD = 30.minutes

  CREATE_LIMIT = 2
  UPDATE_LIMIT = 5
  POST_LIMIT = 5
  COMMENT_LIMIT = 15
  
  # 共通メソッド
  def self.ip(req)
    req.get_header('HTTP_X_FORWARDED_FOR')&.split(',')&.first || req.ip
  end

  def self.match?(req, method, path)
    req.request_method == method && req.path.match?(path)
  end

  # ユーザー登録
  throttle('user registrations', limit: CREATE_LIMIT, period: PERIOD) do |req|
    ip(req) if match?(req, 'POST', %r{\A/users\z})
  end

  # プロフィール更新
  throttle('user profile update', limit: UPDATE_LIMIT, period: PERIOD) do |req|
    ip(req) if match?(req, 'PATCH', %r{\A/user\z})
  end

  # ユーザー投稿(作成・更新)
  throttle('user posts', limit: POST_LIMIT, period: PERIOD) do |req|
    if match?(req, 'POST', %r{\A/users/\d+/posts\z}) ||
       match?(req, 'PATCH', %r{\A/users/\d+/posts/\d+\z})
      ip(req)
    end
  end

  # ユーザーコメント
  throttle('user post comments', limit: COMMENT_LIMIT, period: PERIOD) do |req|
    ip(req) if match?(req, 'POST', %r{\A/users/\d+/posts/\d+/comments\z})
  end

  # グループ作成
  throttle('group create', limit: CREATE_LIMIT, period: PERIOD) do |req|
    ip(req) if match?(req, 'POST', %r{\A/groups\z})
  end

  # グループ更新
  throttle('group update', limit: UPDATE_LIMIT, period: PERIOD) do |req|
    ip(req) if match?(req, 'PATCH', %r{\A/groups/[^/]+\z})
  end

  # グループ投稿(作成・更新)
  throttle('group posts', limit: POST_LIMIT, period: PERIOD) do |req|
    if match?(req, 'POST', %r{\A/groups/[^/]+/posts\z}) ||
       match?(req, 'PATCH', %r{\A/groups/[^/]+/posts/\d+\z})
      ip(req)
    end
  end

  # グループイベント(作成・更新)
  throttle('group events', limit: POST_LIMIT, period: PERIOD) do |req|
    if match?(req, 'POST', %r{\A/groups/[^/]+/events\z}) ||
       match?(req, 'PATCH', %r{\A/groups/[^/]+/events/\d+\z})
      ip(req)
    end
  end

  # グループお知らせ(作成・更新)
  throttle('group notices', limit: POST_LIMIT, period: PERIOD) do |req|
    if match?(req, 'POST', %r{\A/groups/[^/]+/notices\z}) ||
       match?(req, 'PATCH', %r{\A/groups/[^/]+/notices/\d+\z})
      ip(req)
    end
  end

  # グループコメント
  throttle('group post comments', limit: COMMENT_LIMIT, period: PERIOD) do |req|
    ip(req) if match?(req, 'POST', %r{\A/groups/[^/]+/posts/\d+/comments\z})
  end

  # 制限に引っかかった場合のレスポンス
  self.throttled_responder = lambda do |_env|
    [
      429,
      {
        'Content-Type' => 'text/html; charset=utf-8'
      },
      [<<~HTML]
        <!DOCTYPE html>
        <html lang="ja">
        <head>
          <meta charset="UTF-8">
          <title>アクセス制限</title>
        </head>
        <body>
          <h1>アクセスが制限されています</h1>
          <p>しばらく時間を置いてから再度お試しください。</p>
          <br>
          <a href="javascript:history.back()">戻る</a>
        </body>
        </html>
      HTML
    ]
  end
end