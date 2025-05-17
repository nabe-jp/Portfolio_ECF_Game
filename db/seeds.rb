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

puts "男性ユーザー（英語）と女性ユーザー（日本語）を作成しました。"

# 男性ユーザーの投稿（チェス）
post_1 = Post.create!(
  user_id: male_user.id,  # 男性ユーザーのIDを設定
  title: 'Let\'s Play Chess!',
  body: 'I love playing chess. It\'s a great way to sharpen the mind and have fun. Anyone up for a game? Feel free to reach out if you want to play some chess with me!',
)

# チェスの画像を投稿にアタッチ
post_1_image = Rails.root.join('app', 'assets', 'images', 'post_1_chess.jpg')
post_1.post_image.attach(io: File.open(post_1_image), filename: 'post_1_chess.jpg', content_type: 'image/jpeg')

# 男性ユーザーの投稿（ビリヤード）
post_2 = Post.create!(
  user_id: male_user.id,  # 男性ユーザーのIDを設定
  title: 'Billiards Game Night',
  body: 'Billiards is my favorite game! I\'ve been practicing a lot lately. Let\'s have a game night sometime! Who\'s interested in playing billiards with me? I could use some practice!',
)

# ビリヤードの画像を投稿にアタッチ
post_2_image = Rails.root.join('app', 'assets', 'images', 'post_2_billiards.jpg')
post_2.post_image.attach(io: File.open(post_2_image), filename: 'post_2_billiards.jpg', content_type: 'image/jpeg')

# 女性ユーザーの投稿（トランプ）
post_3 = Post.create!(
  user_id: female_user.id,  # 女性ユーザーのIDを設定
  title: 'トランプゲームが楽しい！',
  body: 'トランプは友達と遊ぶのに最高のゲームです！最近、新しいトリックを覚えました。もし一緒に遊べる人がいたら、ぜひ声をかけてくださいね！ゲーム好きな人、集まれ！',
)

# トランプの画像を投稿にアタッチ
post_3_image = Rails.root.join('app', 'assets', 'images', 'post_3_playing_cards.jpg')
post_3.post_image.attach(io: File.open(post_3_image), filename: 'post_3_playing_cards.jpg', content_type: 'image/jpeg')

# 女性ユーザーの投稿（アドベンチャーゲーム）
post_4 = Post.create!(
  user_id: female_user.id,  # 女性ユーザーのIDを設定
  title: 'アドベンチャーゲームの攻略情報',
  body: '最近、アドベンチャーゲームにハマっています！ストーリーが面白くて、ついつい長時間プレイしてしまいます。もしゲーム攻略のコツがあれば教えてください！みんなで情報を交換しませんか？',
)

# アドベンチャーゲームの画像を投稿にアタッチ
post_4_image = Rails.root.join('app', 'assets', 'images', 'post_4_adventure.png')
post_4.post_image.attach(io: File.open(post_4_image), filename: 'post_4_adventure.png', content_type: 'image/png')

puts "男性と女性の投稿（ゲームに関する内容）を作成しました。"

puts "seedの実行が完了しました"
