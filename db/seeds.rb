# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

# コールバックをスキップ
User.skip_callback(:create, :after, :set_default_profile_image)

# 男性ユーザー（英語）
male_user = User.create!(
  email: 'aa@aa',
  password: 'aaaaaa',
  password_confirmation: 'aaaaaa',
  last_name: 'Yamada',
  first_name: 'Taro',
  nickname: 'Tarosan',
  bio: 'Hello, I am Taro Yamada. I am a software engineer.',
  is_active: true
)

# 男性の画像をアタッチ
male_image = Rails.root.join('app', 'assets', 'images', 'user_1.jpg')
male_user.profile_image.attach(io: File.open(male_image), filename: 'user_1.jpg', content_type: 'image/jpeg')

# 女性ユーザー（日本語）
female_user = User.create!(
  email: 'bb@bb',
  password: 'bbbbbb',
  password_confirmation: 'bbbbbb',
  last_name: '田中',
  first_name: '花子',
  nickname: 'はなちゃん',
  bio: 'こんにちは、田中花子です。旅行と写真が大好きです。',
  is_active: true
)

# 女性の画像をアタッチ
female_image = Rails.root.join('app', 'assets', 'images', 'user_2.jpg')
female_user.profile_image.attach(io: File.open(female_image), filename: 'user_2.jpg', content_type: 'image/jpeg')

# コールバックを再登録
User.set_callback(:create, :after, :set_default_profile_image)

puts "男性ユーザー（英語）と女性ユーザー（日本語）を完了しました。"
puts "各投稿の作成を開始します。"

# 男性ユーザーの投稿（チェス）
user_post_1 = UserPost.create!(
  user_id: male_user.id,  # 男性ユーザーのIDを設定
  title: 'Let\'s Play Chess!',
  body: 'I love playing chess. It\'s a great way to sharpen the mind and have fun. Anyone up for a game? Feel free to reach out if you want to play some chess with me!',
)

# チェスの画像を投稿にアタッチ
user_post_1_image = Rails.root.join('app', 'assets', 'images', 'user_post_1_chess.jpg')
user_post_1.user_post_image.attach(io: File.open(user_post_1_image), filename: 'user_post_1_chess.jpg', content_type: 'image/jpeg')

# 男性ユーザーの投稿（ビリヤード）
user_post_2 = UserPost.create!(
  user_id: male_user.id,  # 男性ユーザーのIDを設定
  title: 'Billiards Game Night',
  body: 'Billiards is my favorite game! I\'ve been practicing a lot lately. Let\'s have a game night sometime! Who\'s interested in playing billiards with me? I could use some practice!',
)

# ビリヤードの画像を投稿にアタッチ
user_post_2_image = Rails.root.join('app', 'assets', 'images', 'user_post_2_billiards.jpg')
user_post_2.user_post_image.attach(io: File.open(user_post_2_image), filename: 'user_post_2_billiards.jpg', content_type: 'image/jpeg')

# 女性ユーザーの投稿（トランプ）
user_post_3 = UserPost.create!(
  user_id: female_user.id,  # 女性ユーザーのIDを設定
  title: 'トランプゲームが楽しい！',
  body: 'トランプは友達と遊ぶのに最高のゲームです！最近、新しいトリックを覚えました。もし一緒に遊べる人がいたら、ぜひ声をかけてくださいね！ゲーム好きな人、集まれ！',
)

# トランプの画像を投稿にアタッチ
user_post_3_image = Rails.root.join('app', 'assets', 'images', 'user_post_3_playing_cards.jpg')
user_post_3.user_post_image.attach(io: File.open(user_post_3_image), filename: 'user_post_3_playing_cards.jpg', content_type: 'image/jpeg')

# 女性ユーザーの投稿（アドベンチャーゲーム）
user_post_4 = UserPost.create!(
  user_id: female_user.id,  # 女性ユーザーのIDを設定
  title: 'アドベンチャーゲームの攻略情報',
  body: '最近、アドベンチャーゲームにハマっています！ストーリーが面白くて、ついつい長時間プレイしてしまいます。もしゲーム攻略のコツがあれば教えてください！みんなで情報を交換しませんか？',
)

# アドベンチャーゲームの画像を投稿にアタッチ
user_post_4_image = Rails.root.join('app', 'assets', 'images', 'user_post_4_adventure.png')
user_post_4.user_post_image.attach(io: File.open(user_post_4_image), filename: 'user_post_4_adventure.png', content_type: 'image/png')

puts "男性と女性の投稿（ゲームに関する内容）を完了しました。"
puts "投稿に対してのコメントの作成を開始します。"
# コメント作成（投稿ごとに 0〜3 件ランダム生成）
[user_post_1, user_post_2, user_post_3, user_post_4].each do |post|
  rand(0..3).times do |i|
    UserPostComment.create!(
      user: [male_user, female_user].sample,
      user_post: post,
      body: "これは投稿#{post.id}へのコメント#{i + 1}です。",
      like_count: rand(0..10),
      parent_comment_id: nil
    )
  end
end

puts "投稿に対してのコメントの作成を完了しました。"
puts "管理側の作成を開始します。"

admin_email = ENV['ADMIN_EMAIL']
admin_password = ENV['ADMIN_PASSWORD']

if admin_email.blank? || admin_password.blank?
  puts "⚠ 管理者の環境変数が設定されていません"
else
  Admin.find_or_create_by!(email: admin_email) do |admin|
    admin.password = admin_password
    admin.password_confirmation = admin_password
  end

  puts "管理側の作成を完了しました。"
end

puts "管理側ノートの作成を開始します。"

admin = Admin.find_by(email: admin_email)

AdminNote.create!([
  {
    title: "削除+固定表示",
    body: "これは削除され固定表示されたノートです。",
    admin: admin,
    is_pinned: true,
    deleted_at: Time.current
  },
  {
    title: "削除のみ",
    body: "これは削除されただけのノートです。",
    admin: admin,
    is_pinned: false,
    deleted_at: Time.current
  },
  {
    title: "固定表示のみ",
    body: "これは削除されておらず固定表示されているノートです。",
    admin: admin,
    is_pinned: true
  },
  {
    title: "フラグなし",
    body: "フラグが立っていないノートです。",
    admin: admin,
    is_pinned: false,
  }
])

puts "管理者ノートの作成を完了しました。"
puts "お知らせの作成を開始します。"

Information.create!([
  {
    title: "削除+固定表示+非公開",
    body: "すべてのフラグが立っているお知らせです。",
    published_at: 3.days.ago,
    visible: false,
    is_pinned: true,
    deleted_at: Time.current,
    admin: admin
  },
  {
    title: "削除+非公開",
    body: "削除かつ非公開のお知らせです。",
    published_at: 2.days.ago,
    visible: false,
    is_pinned: false,
    deleted_at: Time.current,
    admin: admin
  },
  {
    title: "削除+固定表示",
    body: "削除かつ固定表示のお知らせです。",
    published_at: 5.days.ago,
    visible: true,
    is_pinned: true,
    deleted_at: Time.current,
    admin: admin
  },
  {
    title: "固定表示+非公開",
    body: "固定表示かつ非公開のお知らせです。",
    published_at: 1.day.ago,
    visible: false,
    is_pinned: true,
    admin: admin
  },
  {
    title: "非公開",
    body: "非公開のお知らせです。",
    published_at: 4.days.ago,
    visible: false,
    is_pinned: false,
    admin: admin
  },
  {
    title: "固定表示",
    body: "固定表示されているお知らせです。",
    published_at: 6.days.ago,
    visible: true,
    is_pinned: true,
    admin: admin
  },
  {
    title: "フラグなし",
    body: "フラグが立っていないノートです。",
    published_at: 12.days.ago,
    visible: true,
    is_pinned: false,
    admin: admin
  }
])

puts "お知らせをの作成を完了しました。"
puts "seedの実行が完了しました。"
