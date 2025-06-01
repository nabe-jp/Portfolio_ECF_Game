# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始しました"
puts "ユーザーの作成を開始します"
# コールバックをスキップ
User.skip_callback(:create, :after, :set_default_profile_image)

# === ユーザー（英語）
male_user_1 = User.find_or_initialize_by(id: 1)
male_user_1.update!(
  email: 'aa@aa',
  password: 'aaaaaa',
  password_confirmation: 'aaaaaa',
  last_name: 'Yamada',
  first_name: 'Taro',
  nickname: 'Tarosan',
  bio: 'Hello, I am Taro Yamada. I am a software engineer.',
  is_deleted: false
)
male_image_1 = Rails.root.join('app', 'assets', 'images', 'user_1.jpg')
male_user_1.profile_image.attach(io: File.open(male_image_1), filename: 'user_1.jpg', content_type: 'image/jpeg') unless male_user_1.profile_image.attached?

# === ユーザー（日本語）
female_user_2 = User.find_or_initialize_by(id: 2)
female_user_2.update!(
  email: 'bb@bb',
  password: 'bbbbbb',
  password_confirmation: 'bbbbbb',
  last_name: '田中',
  first_name: '花子',
  nickname: 'はなちゃん',
  bio: 'こんにちは、田中花子です。旅行と写真が大好きです。',
  is_deleted: false
)
female_image_2 = Rails.root.join('app', 'assets', 'images', 'user_2.jpg')
female_user_2.profile_image.attach(io: File.open(female_image_2), filename: 'user_2.jpg', content_type: 'image/jpeg') unless female_user_2.profile_image.attached?

female_user_3 = User.find_or_initialize_by(id: 3)
female_user_3.update!(
  email: 'cc@cc',
  password: 'cccccc',
  password_confirmation: 'cccccc',
  last_name: '佐藤',
  first_name: '美咲',
  nickname: 'みさきちゃん',
  bio: 'こんにちは！ゲーム実況が趣味の佐藤美咲です♪',
  is_deleted: false
)
female_image_3 = Rails.root.join('app', 'assets', 'images', 'user_3.jpg')
female_user_3.profile_image.attach(io: File.open(female_image_3), filename: 'user_3.jpg', content_type: 'image/jpeg') unless female_user_3.profile_image.attached?

male_user_4 = User.find_or_initialize_by(id: 4)
male_user_4.update!(
  email: 'dd@dd',
  password: 'dddddd',
  password_confirmation: 'dddddd',
  last_name: '鈴木',
  first_name: '一郎',
  nickname: 'イチロー',
  bio: 'どんなゲームもまずやってみる派！よろしく！',
  is_deleted: false
)
male_image_4 = Rails.root.join('app', 'assets', 'images', 'user_4.jpg')
male_user_4.profile_image.attach(io: File.open(male_image_4), filename: 'user_4.jpg', content_type: 'image/jpeg') unless male_user_4.profile_image.attached?

# === 削除ユーザー（画像なし）
deleted_user_5 = User.find_or_initialize_by(id: 5)
deleted_user_5.update!(
  email: 'ee@ee',
  password: 'eeeeee',
  password_confirmation: 'eeeeee',
  last_name: '退会',
  first_name: 'ユーザー',
  nickname: '旧ユーザー',
  bio: 'このユーザーは退会しています。',
  is_deleted: true,
  deleted_at: Time.current
)
deleted_image_5 = Rails.root.join('app', 'assets', 'images', 'no_user.png')
deleted_user_5.profile_image.attach(io: File.open(deleted_image_5), filename: 'no_user.png', content_type: 'image/png') unless deleted_user_5.profile_image.attached?

female_user_6 = User.find_or_initialize_by(id: 6)
female_user_6.update!(
  email: 'ff@ff',
  password: 'ffffff',
  password_confirmation: 'ffffff',
  last_name: 'Brown',
  first_name: 'Emily',
  nickname: 'Emmy',
  bio: 'Hi! I love puzzle games and cute avatars!',
  is_deleted: false
)
female_image_6 = Rails.root.join('app', 'assets', 'images', 'user_6.jpg')
female_user_6.profile_image.attach(io: File.open(female_image_6), filename: 'user_6.jpg', content_type: 'image/jpeg') unless female_user_6.profile_image.attached?

user_7 = User.find_or_initialize_by(id: 7)
user_7.update!(
  email: 'gg@gg',
  password: 'gggggg',
  password_confirmation: 'gggggg',
  last_name: '岡田',
  first_name: '直樹',
  nickname: 'ナオ',
  bio: 'グラフィック系のゲームが大好きです！',
  is_deleted: false
)
user_image_7 = Rails.root.join('app', 'assets', 'images', 'no_user.png')
user_7.profile_image.attach(io: File.open(user_image_7), filename: 'no_user.png', content_type: 'image/png') unless user_7.profile_image.attached?

female_user_8 = User.find_or_initialize_by(id: 8)
female_user_8.update!(
  email: 'hh@hh',
  password: 'hhhhhh',
  password_confirmation: 'hhhhhh',
  last_name: 'Smith',
  first_name: 'Lily',
  nickname: 'Lilypad',
  bio: 'Retro-style games are my jam! Let’s connect :)',
  is_deleted: false
)
female_image_8 = Rails.root.join('app', 'assets', 'images', 'user_8.jpg')
female_user_8.profile_image.attach(io: File.open(female_image_8), filename: 'user_8.jpg', content_type: 'image/jpeg') unless female_user_8.profile_image.attached?

male_user_9 = User.find_or_initialize_by(id: 9)
male_user_9.update!(
  email: 'ii@ii',
  password: 'iiiiii',
  password_confirmation: 'iiiiii',
  last_name: '高橋',
  first_name: '陽介',
  nickname: 'ようすけ',
  bio: 'アクションゲームのスピード感やファンタジーゲームの世界観が好きです！',
  is_deleted: false
)
male_image_9 = Rails.root.join('app', 'assets', 'images', 'user_9.jpg')
male_user_9.profile_image.attach(io: File.open(male_image_9), filename: 'user_9.jpg', content_type: 'image/jpeg') unless male_user_9.profile_image.attached?

user_10 = User.find_or_initialize_by(id: 10)
user_10.update!(
  email: 'jj@jj',
  password: 'jjjjjj',
  password_confirmation: 'jjjjjj',
  last_name: '西村',
  first_name: '彩乃',
  nickname: 'あやのん',
  bio: 'ほんわか癒し系ゲームをよく探しています〜',
  is_deleted: false
)
user_image_10 = Rails.root.join('app', 'assets', 'images', 'no_user.png')
user_10.profile_image.attach(io: File.open(user_image_10), filename: 'no_user.png', content_type: 'image/png') unless user_10.profile_image.attached?

male_user_11 = User.find_or_initialize_by(id: 11)
male_user_11.update!(
  email: 'kk@kk',
  password: 'kkkkkk',
  password_confirmation: 'kkkkkk',
  last_name: 'Johnson',
  first_name: 'David',
  nickname: 'DaveJ',
  bio: 'Indie games enthusiast. I test and review prototypes.',
  is_deleted: false
)
male_image_11 = Rails.root.join('app', 'assets', 'images', 'user_11.jpg')
male_user_11.profile_image.attach(io: File.open(male_image_11), filename: 'user_11.jpg', content_type: 'image/jpeg') unless male_user_11.profile_image.attached?

user_12 = User.find_or_initialize_by(id: 12)
user_12.update!(
  email: 'll@ll',
  password: 'llllll',
  password_confirmation: 'llllll',
  last_name: '中村',
  first_name: '千春',
  nickname: 'ちーちゃん',
  bio: '最近はゆるく楽しめるゲームをメインに遊んでます♪',
  is_deleted: false
)
user_image_12 = Rails.root.join('app', 'assets', 'images', 'no_user.png')
user_12.profile_image.attach(io: File.open(user_image_12), filename: 'no_user.png', content_type: 'image/png') unless user_12.profile_image.attached?


# コールバックを再登録
User.set_callback(:create, :after, :set_default_profile_image)

puts "ユーザーの作成を完了しました"
puts "ユーザー投稿の作成を開始します"

# 投稿ID: 1チェス）
user_post_1 = UserPost.create!(
  id: 1,
  user: male_user_1,
  title: 'Let\'s Play Chess!',
  body: 'I love playing chess. It\'s a great way to sharpen the mind and have fun. Anyone up for a game? Feel free to reach out if you want to play some chess with me!',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_1 = Rails.root.join('app', 'assets', 'images', 'user_post_1_chess.jpg')
user_post_1.user_post_image.attach(io: File.open(user_post_image_1), filename: 'user_post_1_chess.jpg', content_type: 'image/jpeg')

# 投稿ID: 2（ビリヤード）
user_post_2 = UserPost.create!(
  id: 2,
  user: male_user_1,
  title: 'Billiards Game Night',
  body: 'Billiards is my favorite game! I\'ve been practicing a lot lately. Let\'s have a game night sometime! Who\'s interested in playing billiards with me? I could use some practice!',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_2= Rails.root.join('app', 'assets', 'images', 'user_post_2_billiards.jpg')
user_post_2.user_post_image.attach(io: File.open(user_post_image_2), filename: 'user_post_2_billiards.jpg', content_type: 'image/jpeg')

# 投稿ID: 3（トランプ）
user_post_3 = UserPost.create!(
  id: 3,
  user: female_user_2,
  title: 'トランプゲームが楽しい！',
  body: 'トランプは友達と遊ぶのに最高のゲームです！最近、新しいトリックを覚えました。もし一緒に遊べる人がいたら、ぜひ声をかけてくださいね！ゲーム好きな人、集まれ！',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_3 = Rails.root.join('app', 'assets', 'images', 'user_post_3_playing_cards.jpg')
user_post_3.user_post_image.attach(io: File.open(user_post_image_3), filename: 'user_post_3_playing_cards.jpg', content_type: 'image/jpeg')

# 投稿ID: 4（アドベンチャーゲーム）
user_post_4 = UserPost.create!(
  id: 4,
  user: female_user_2,
  title: 'アドベンチャーゲームの攻略情報',
  body: '最近、アドベンチャーゲームにハマっています！ストーリーが面白くて、ついつい長時間プレイしてしまいます。もしゲーム攻略のコツがあれば教えてください！みんなで情報を交換しませんか？',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_4 = Rails.root.join('app', 'assets', 'images', 'user_post_4_adventure.png')
user_post_4.user_post_image.attach(io: File.open(user_post_image_4), filename: 'user_post_4_adventure.png', content_type: 'image/png')

# 投稿ID: 5（画像なし）
user_post_5 = UserPost.create!(
  id: 5,
  user: user_7,
  title: '時間泥棒な放置ゲーム',
  body: 'アイテムを強化していくだけの放置系ゲーム。やめ時が分からなくなる中毒性あり。',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_5 = Rails.root.join('app', 'assets', 'images', 'no_user_post.png')
user_post_5.user_post_image.attach(io: File.open(user_post_image_5), filename: 'no_user_post.png', content_type: 'image/png')

# 投稿ID: 6（ホラー）
user_post_6 = UserPost.create!(
  id: 6,
  user: user_7,
  title: '闇夜の館からの脱出',
  body: '薄暗い洋館に閉じ込められたあなたは、奇妙な現象と戦いながら脱出を目指します。果たして朝日を見ることができるのか…？',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_6 = Rails.root.join('app', 'assets', 'images', 'user_post_6_horror.jpg')
user_post_6.user_post_image.attach(io: File.open(user_post_image_6), filename: 'user_post_6_horror.jpg', content_type: 'image/jpeg')

# 投稿ID: 7（画像なし）
user_post_7 = UserPost.create!(
  id: 7,
  user: deleted_user_5,
  title: 'タップで進むアドベンチャー',
  body: 'シンプル操作で楽しめるストーリー主体のゲーム。選択によって物語が分岐します。',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_7 = Rails.root.join('app', 'assets', 'images', 'no_user_post.png')
user_post_7.user_post_image.attach(io: File.open(user_post_image_7), filename: 'no_user_post.png', content_type: 'image/png')

# 投稿ID: 8（サッカー）
user_post_8 = UserPost.create!(
  id: 8,
  user: user_10,
  title: 'ミニサッカーゲームを作ってみた！',
  body: '2Dフィールドで遊べるシンプルなサッカーゲームです。カーソルキーで移動、スペースでキック！1人でも2人でも遊べます⚽',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_8 = Rails.root.join('app', 'assets', 'images', 'user_post_8_soccer.jpg')
user_post_8.user_post_image.attach(io: File.open(user_post_image_8), filename: 'user_post_8_soccer.jpg', content_type: 'image/jpeg')

# 投稿ID: 9（ダークファンタジー）
user_post_9 = UserPost.create!(
  id: 9,
  user: male_user_9,
  title: '呪われた王国の物語',
  body: 'プレイヤーは滅びかけた王国の最後の騎士。闇の呪いを解くため、失われた記憶と謎に挑むダークファンタジーRPGです。',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_9 = Rails.root.join('app', 'assets', 'images', 'user_post_9_dark_fantasy.jpg')
user_post_9.user_post_image.attach(io: File.open(user_post_image_9), filename: 'user_post_9_dark_fantasy.jpg', content_type: 'image/jpeg')

# 投稿ID: 10（削除済み）
user_post_10 = UserPost.create!(
  id: 10,
  user: male_user_1,
  title: 'テスト投稿（削除）',
  body: 'この投稿は削除済みの投稿の例です。',
  is_deleted: true,
  is_public: true,
  is_pinned: false,
)
user_post_image_10 = Rails.root.join('app', 'assets', 'images', 'no_user_post.png')
user_post_10.user_post_image.attach(io: File.open(user_post_image_10), filename: 'no_user_post.png', content_type: 'image/png')

# 投稿ID: 11（非公開）
user_post_11 = UserPost.create!(
  id: 11,
  user: deleted_user_5,
  title: '戦略で勝利を掴め！',
  body: 'ユニットを配置して、敵陣を攻略していくターン制の戦略ゲーム。じっくり思考を楽しみたい方におすすめです。',
  is_deleted: false,
  is_public: false,
  is_pinned: false,
)
user_post_image_11 = Rails.root.join('app', 'assets', 'images', 'user_post_11_strategy.jpg')
user_post_11.user_post_image.attach(io: File.open(user_post_image_11), filename: 'user_post_11_strategy.jpg', content_type: 'image/jpeg')

# 投稿ID: 12（パズル）
user_post_12 = UserPost.create!(
  id: 12,
  user: female_user_6,
  title: 'Brain training!',
  body: "We've put together a variety of logic puzzles in one app. Try one puzzle a day in your spare time!",
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_12 = Rails.root.join('app', 'assets', 'images', 'user_post_12_puzzle.png')
user_post_12.user_post_image.attach(io: File.open(user_post_image_12), filename: 'user_post_12_puzzle.png', content_type: 'image/png')

# 投稿ID: 13（恋愛）
user_post_13 = UserPost.create!(
  id: 13,
  user: male_user_11,
  title: '恋する高校生活シミュレーション',
  body: '学園生活の中でさまざまなキャラと関係を築いていく恋愛シミュレーション。選択肢によって結末が変わるマルチエンディング。',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_13 = Rails.root.join('app', 'assets', 'images', 'user_post_13_love_affair.jpg')
user_post_13.user_post_image.attach(io: File.open(user_post_image_13), filename: 'user_post_13_love_affair.jpg', content_type: 'image/jpeg')

# 投稿ID: 14（ダイスバトル）
user_post_14 = UserPost.create!(
  id: 14,
  user: male_user_4,
  title: '運を味方につけろ！ダイスバトル',
  body: '2人で交互にダイスを振り、攻防を繰り広げる運と戦略のバトルゲーム。リアルタイムでも対戦できます。',
  is_deleted: false,
  is_public: true,
  is_pinned: false,
)
user_post_image_14 = Rails.root.join('app', 'assets', 'images', 'user_post_14_dice.jpg')
user_post_14.user_post_image.attach(io: File.open(user_post_image_14), filename: 'user_post_14_dice.jpg', content_type: 'image/jpeg')

puts "ユーザー投稿の作成を完了しました"
puts "ユーザー投稿に対してのコメントの作成を開始しました"

# コメント作成
UserPostComment.create!([
  {
    user_id: 3,
    user_post_id: 1,
    body: 'この投稿、とても参考になりました。ありがとうございます！',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 4,
    user_post_id: 1,
    body: 'ちょうど似たような課題に直面していたので助かりました。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 5,
    user_post_id: 1,
    body: 'Great write-up! I liked the second part the most.',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 6,
    user_post_id: 1,
    body: '図を使って説明してくれるともっと分かりやすいかもしれません。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 7,
    user_post_id: 1,
    body: 'うーん、私はこのやり方は少し複雑に感じました。',
    is_deleted: true,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 8,
    user_post_id: 1,
    body: 'コメントありがとうございます！追記で図解も検討しますね。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 4,
    replied_at: nil
  },
  {
    user_id: 9,
    user_post_id: 1,
    body: '私はすごくわかりやすかったです。初心者でも理解できました。',
    is_deleted: false,
    is_public: false,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 5,
    user_post_id: 2,
    body: 'この記事すごく分かりやすくて2回読み返しました！',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 5,
    user_post_id: 2,
    body: '特に「データ構造」の部分、勉強になりました。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 6,
    user_post_id: 2,
    body: 'どのあたりが勉強になったか具体的に教えてもらえますか？',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 2,
    replied_at: nil
  },
  {
    user_id: 5,
    user_post_id: 2,
    body: 'たとえばハッシュの部分！コード例付きで助かりました。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 3,
    replied_at: nil
  },
  {
    user_id: 3,
    user_post_id: 2,
    body: 'わたしもそこ気になってた。例があると理解しやすいよね。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 2,
    replied_at: nil
  },
  {
    user_id: 7,
    user_post_id: 2,
    body: 'コード部分、もう少し説明欲しかったなと思いました。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 8,
    user_post_id: 2,
    body: '私はちょうどよかったと思いましたよ。長すぎると読まないし。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 6,
    replied_at: nil
  },
  {
    user_id: 9,
    user_post_id: 2,
    body: 'この投稿がきっかけでRuby触ってみようと思いました！',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 6,
    user_post_id: 3,
    body: '最近同じことで悩んでたから、すごく刺さった。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 8,
    user_post_id: 3,
    body: '自分だけかと思ってたけど、みんな似たようなこと感じてるんだね。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 1,
    replied_at: nil
  },
  {
    user_id: 5,
    user_post_id: 3,
    body: '読んでて涙が出そうになった...。ありがとう。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 3,
    user_post_id: 3,
    body: '勇気を出して投稿してくれてありがとう。',
    is_deleted: true,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 4,
    user_post_id: 3,
    body: 'コメントしようか迷ったけど…本当に感謝しています。',
    is_deleted: false,
    is_public: false,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 9,
    user_post_id: 3,
    body: 'こういうテーマってなかなか口に出しにくいから大事だと思う。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 7,
    user_post_id: 3,
    body: 'ネガティブな気持ちも受け止めてくれる空気があっていいね。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 6,
    replied_at: nil
  },
  {
    user_id: 10,
    user_post_id: 3,
    body: 'こういう話題、もっと表に出てほしい。共感の嵐でした。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 11,
    user_post_id: 3,
    body: '投稿に救われた人、たくさんいると思います。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 5,
    user_post_id: 4,
    body: 'すごく丁寧にまとめられていて、読みやすかったです！',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 6,
    user_post_id: 4,
    body: 'こういう系の記事もっと読みたい。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 1,
    replied_at: nil
  },
  {
    user_id: 3,
    user_post_id: 4,
    body: '初心者にも分かりやすくて助かりました！',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 7,
    user_post_id: 4,
    body: '間違って削除したファイルの復元方法とかも知りたいな。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: 3,
    replied_at: nil
  },
  {
    user_id: 9,
    user_post_id: 4,
    body: '次回作も楽しみにしてます😊',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 4,
    user_post_id: 4,
    body: '自分も最近似たような内容を調べてたところだったので参考になりました！',
    is_deleted: false,
    is_public: false,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 8,
    user_post_id: 4,
    body: 'こういう情報共有文化、もっと広がってほしい。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 10,
    user_post_id: 4,
    body: 'いつも有益な投稿ありがとうございます！',
    is_deleted: true,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 11,
    user_post_id: 4,
    body: '技術の話だけでなく、背景まで書いてくれてるのが良かった。',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 6,
    user_post_id: 10,
    body: 'この記事、削除されてしまったのは惜しいですね…',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 3,
    user_post_id: 10,
    body: '保存しておけばよかった～',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 9,
    user_post_id: 10,
    body: 'コメントだけでも残ってるのありがたい',
    is_deleted: false,
    is_public: false,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 4,
    user_post_id: 11,
    body: 'まだ非公開みたいですが、楽しみに待ってます！',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 5,
    user_post_id: 11,
    body: '限定公開ですか？それとも調整中？',
    is_deleted: false,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  },
  {
    user_id: 8,
    user_post_id: 11,
    body: '見れないけどコメントはできるんですね笑',
    is_deleted: true,
    is_public: true,
    parent_comment_id: nil,
    replied_at: nil
  }
])

puts "ユーザー投稿に対してのコメントの作成を完了しました。"
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
    created_at: 6.days.ago,
    is_pinned: true,
    deleted_at: Time.current,
    admin: admin
  },
  {
    title: "削除のみ",
    body: "これは削除されただけのノートです。",
    created_at: 4.days.ago,
    is_pinned: false,
    deleted_at: Time.current,
    admin: admin
  },
  {
    title: "固定表示のみ",
    body: "これは削除されておらず固定表示されているノートです。",
    created_at: 3.days.ago,
    is_pinned: true,
    admin: admin
  },
  {
    title: "フラグなし",
    body: "フラグが立っていないノートです。",
    is_pinned: false,
    admin: admin
  }
])

puts "管理者ノートの作成を完了しました"
puts "お知らせの作成を開始します"

Information.create!([
  {
    title: "削除+固定表示+非公開",
    body: "すべてのフラグが立っているお知らせです。",
    published_at: 9.days.ago,
    created_at: 10.days.ago,
    is_public: false,
    is_pinned: true,
    deleted_at: Time.current,
    admin: admin
  },
  {
    title: "削除+非公開",
    body: "削除かつ非公開のお知らせです。",
    published_at: 7.days.ago,
    created_at: 9.days.ago,
    is_public: false,
    is_pinned: false,
    deleted_at: Time.current,
    admin: admin
  },
  {
    title: "削除+固定表示",
    body: "削除かつ固定表示のお知らせです。",
    published_at: 5.days.ago,
    created_at: 6.days.ago,
    is_public: true,
    is_pinned: true,
    deleted_at: Time.current,
    admin: admin
  },
  {
    title: "固定表示+非公開",
    body: "固定表示かつ非公開のお知らせです。",
    published_at: 4.day.ago,
    created_at: 4.days.ago,
    is_public: false,
    is_pinned: true,
    admin: admin
  },
  {
    title: "非公開",
    body: "非公開のお知らせです。",
    published_at: 2.days.ago,
    created_at: 3.days.ago,
    is_public: false,
    is_pinned: false,
    admin: admin
  },
  {
    title: "固定表示",
    body: "固定表示されているお知らせです。",
    published_at: 1.days.ago,
    created_at: 1.days.ago,
    is_public: true,
    is_pinned: true,
    admin: admin
  },
  {
    title: "フラグなし",
    body: <<~TEXT,
      フラグが立っていないノートです。
      seedにて投稿日公開日を入れている投稿に関しては並び替えが適切に変わらない恐れがあります。
    TEXT
    published_at: Time.current,
    created_at: Time.current,
    is_public: true,
    is_pinned: false,
    admin: admin
  }
])

puts "お知らせをの作成を完了しました"
puts "seedの実行が完了しました"
