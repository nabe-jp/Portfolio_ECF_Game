# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# トランザクションを使用し、エラー時にseedを生成しない
ActiveRecord::Base.transaction do
  puts "seedの実行を開始しました"
  puts "管理側の作成を開始します。"

  admin_email = ENV['ADMIN_EMAIL']
  admin_password = ENV['ADMIN_PASSWORD']

  if admin_email.blank? || admin_password.blank?
    # エラーを出して処理を中断する
    raise "⚠ 管理者の環境変数が設定されていません"
  else
    Admin.find_or_create_by!(email: admin_email) do |admin|
      admin.password = admin_password
      admin.password_confirmation = admin_password
    end

    puts "管理側の作成を完了しました。"
  end

  puts "ユーザーの作成を開始します"

  # コールバックをスキップ
  User.skip_callback(:create, :after, :set_default_profile_image)

  # 英語・日本語によるユーザーの作成(male、femaleで性別を分け、中性はuser、削除専用はdeleted)
  user_images = [
    'user_ja_male_1',
    'user_ja_male_2',
    'user_ja_male_3',
    'user_ja_female_1',
    'user_ja_female_2',
    'user_ja_female_3',
    'user_ja_1',
    'user_en_male_1',
    'user_en_male_2',
    'user_en_male_3',
    'user_en_female_1',
    'user_en_female_2',
    'user_en_female_3',
    'user_en_1'
  ]

  users = [
    {
      email: 'aa@aa',
      password: 'aaaaaa',
      last_name: '鈴木',
      first_name: '太郎',
      nickname: 'すーさん',
      bio: '囲碁と将棋が好きで、特に戦略を考えるのが得意です。',
      image: 'user_ja_male_1'
    },
    {
      email: 'bb@bb',
      password: 'bbbbbb',
      last_name: '佐藤',
      first_name: '健一',
      nickname: 'けんちゃん',
      bio: '最近ビリヤードにはまっています。的確なショットにこだわりあり。',
      image: 'user_ja_male_2'
    },
    {
      email: 'cc@cc',
      password: 'cccccc',
      last_name: '中村',
      first_name: '翔',
      nickname: 'Sho',
      bio: '暗闇でのサバイバルゲームが大好きです！次の作戦を練っています。',
      image: 'user_ja_male_3'
    },
    {
      email: 'dd@dd',
      password: 'dddddd',
      last_name: '高橋',
      first_name: '美咲',
      nickname: 'Misa',
      bio: 'パズルと謎解きゲームで頭を使うのが大好きです。',
      image: 'user_ja_female_1'
    },
    {
      email: 'ee@ee',
      password: 'eeeeee',
      last_name: '小林',
      first_name: '葵',
      nickname: 'あおいんぐ',
      bio: '恋愛シミュレーションゲームにどっぷり浸かっています。',
      image: 'user_ja_female_2'
    },
    {
      email: 'ff@ff',
      password: 'ffffff',
      last_name: '山本',
      first_name: '玲奈',
      nickname: 'RenaGamer',
      bio: 'ホラーゲーム好きですが、怖がりなので一人では無理かも。',
      image: 'user_ja_female_3'
    },
    {
      email: 'gg@gg',
      password: 'gggggg',
      last_name: '井上',
      first_name: '未知',
      nickname: 'mysteryJPN',
      bio: 'どんなジャンルのゲームも試したくなる探究心旺盛なタイプです。',
      image: 'user_ja_1'
    },
    {
      email: 'hh@hh',
      password: 'hhhhhh',
      last_name: 'Smith',
      first_name: 'John',
      nickname: 'JohnnyB',
      bio: 'Fighting games and action-packed stories are what I live for.',
      image: 'user_en_male_1'
    },
    {
      email: 'ii@ii',
      password: 'iiiiii',
      last_name: 'Brown',
      first_name: 'Mike',
      nickname: 'MikeyMike',
      bio: 'I dabble in many genres, from music games to sci-fi strategy.',
      image: 'user_en_male_2'
    },
    {
      email: 'jj@jj',
      password: 'jjjjjj',
      last_name: 'Wilson',
      first_name: 'Eric',
      nickname: 'E-Rock',
      bio: 'Puzzle games are my go-to for relaxation and focus.',
      image: 'user_en_male_3'
    },
    {
      email: 'kk@kk',
      password: 'kkkkkk',
      last_name: 'Taylor',
      first_name: 'Emily',
      nickname: 'EmTay',
      bio: 'I love fantasy adventures and building teams to overcome quests.',
      image: 'user_en_female_1'
    },
    {
      email: 'll@ll',
      password: 'llllll',
      last_name: 'Johnson',
      first_name: 'Sophia',
      nickname: 'SophGamer',
      bio: 'Dark fantasy RPGs are my favorite. I love a good immersive story.',
      image: 'user_en_female_2'
    },
    {
      email: 'mm@mm',
      password: 'mmmmmm',
      last_name: 'Martinez',
      first_name: 'Luna',
      nickname: 'MoonCat',
      bio: 'I enjoy city-building and simulation games in my spare time.',
      image: 'user_en_female_3'
    },
    {
      email: 'nn@nn',
      password: 'nnnnnn',
      last_name: 'Lee',
      first_name: 'Alex',
      nickname: 'A.L.X',
      bio: 'Love chess and space strategy games. Thinking ahead is my game.',
      image: 'user_en_1'
    }
  ]

  users.each do |attrs|
    user = User.create!(
      email: attrs[:email],
      password: attrs[:password],
      password_confirmation: attrs[:password],
      last_name: attrs[:last_name],
      first_name: attrs[:first_name],
      nickname: attrs[:nickname],
      bio: attrs[:bio],
      user_status: :active
    )

    image_path = Rails.root.join('app', 'assets', 'images', "#{attrs[:image]}.jpg")
    user.profile_image.attach(io: File.open(image_path), filename: "#{attrs[:image]}.jpg",
      content_type: 'image/jpeg')
  end


  # # 削除ユーザー(サイト管理者により削除)
  # deleted_user_13 = User.find_or_initialize_by(id: 13)
  # deleted_user_13.update!(
  #   email: 'mm@',
  #   password: 'mmmmmm',
  #   password_confirmation: 'mmmmmm',
  #   last_name: '強制退会用',
  #   first_name: 'ユーザー',
  #   nickname: '強制退会ユーザー',
  #   bio: '強制退会専用のユーザーです',
  #   user_status: :deactivated,
  #   deleted_at: Time.current,
  #   deleted_by_id: '',
  #   deleted_reason: :removed_by_admin
  # )
  # deleted_image_13 = Rails.root.join('app', 'assets', 'images', 'no_user.png')
  # deleted_user_13.profile_image.attach(io: File.open(deleted_image_13), filename: 'no_user.png', 
  #   content_type: 'image/png') unless deleted_user_13.profile_image.attached?


  # コールバックを再登録
  User.set_callback(:create, :after, :set_default_profile_image)

  puts "ユーザーの作成を完了しました"
  puts "ユーザー投稿の作成を開始します"

  # コールバックをスキップ
  UserPost.skip_callback(:create, :after, :set_default_user_post_image)

  user_post_images = [
    'user_post_1_chess',
    'user_post_2_billiards',
    'user_post_3_playing_cards',
    'user_post_4_dice',
    'user_post_5_love_affair',
    'user_post_6_horror',
    'user_post_7_survival',
    'user_post_8_racing',
    'user_post_9_fighting_games',
    'user_post_10_sports',
    'user_post_11_music',
    'user_post_12_puzzle',
    'user_post_13_action',
    'user_post_14_adventure',
    'user_post_15_dark_fantasy',
    'user_post_16_fantasy',
    'user_post_17_city_planning_simulation',
    'user_post_18_cultivation',
    'user_post_19_strategy',
    'user_post_20_sf_strategy'
  ]

  user_posts = [
    {
      user_index: 0,
      title: '勝負の読み合い',
      body: 'チェスでの一手一手の重みがたまらない。思考を巡らせるのが楽しい。',
      image: 'user_post_1_chess'
    },
    {
      user_index: 0,
      title: '宇宙戦線へ出撃',
      body: '宇宙空間での戦闘がテーマのSF戦略ゲームにドハマリ中。',
      image: 'user_post_20_sf_strategy'
    },
    {
      user_index: 1,
      title: 'ナイスショット！',
      body: '最近、ビリヤードでブレイクショットがきれいに決まるようになった。',
      image: 'user_post_2_billiards'
    },
    {
      user_index: 2,
      title: '夜の森を抜けて',
      body: 'サバイバルゲームで無人島を探索。準備が命を分ける！',
      image: 'user_post_7_survival'
    },
    {
      user_index: 3,
      title: '神経戦の日々',
      body: 'トランプゲームでの心理戦がやめられない。いつも全力で挑んでいます。',
      image: 'user_post_3_playing_cards'
    },
    {
      user_index: 3,
      title: 'ダイス運命論',
      body: 'サイコロ一投で運命が決まるのがスリリングで好き。',
      image: 'user_post_4_dice'
    },
    {
      user_index: 4,
      title: '乙女の恋模様',
      body: 'ゲーム内での恋愛シナリオが切なくて胸がきゅんとする。',
      image: 'user_post_5_love_affair'
    },
    {
      user_index: 5,
      title: '深夜の恐怖体験',
      body: 'ホラーゲームの音と演出がリアルすぎて一人でできないレベル。',
      image: 'user_post_6_horror'
    },
    {
      user_index: 5,
      title: '戦術勝負が熱い',
      body: '相手の動きを読んで勝利する戦略ゲームに夢中。',
      image: 'user_post_19_strategy'
    },
    {
      user_index: 6,
      title: '街を駆け抜ける',
      body: 'レースゲームのタイムアタックで自己ベスト更新を目指してます。',
      image: 'user_post_8_racing'
    },
    {
      user_index: 7,
      title: 'Fighting Spirit!',
      body: 'Practicing combos is tough, but the thrill of victory in a match is unbeatable.',
      image: 'user_post_9_fighting_games'
    },
    {
      user_index: 8,
      title: 'Teaming Up',
      body: 'Nothing beats forming a team and winning together in sports games!',
      image: 'user_post_10_sports'
    },
    {
      user_index: 8,
      title: 'Feel the Rhythm',
      body: 'Trying to achieve a full combo on my favorite music game. Love the tempo!',
      image: 'user_post_11_music'
    },
    {
      user_index: 9,
      title: 'Puzzle Joy',
      body: 'There’s nothing like the satisfaction of cracking a tough puzzle.',
      image: 'user_post_12_puzzle'
    },
    {
      user_index: 10,
      title: 'Onward Adventure',
      body: 'Exploring new lands in adventure games always gets me excited.',
      image: 'user_post_14_adventure'
    },
    {
      user_index: 11,
      title: 'Light & Darkness',
      body: 'I adore the world-building in dark fantasy RPGs—so immersive.',
      image: 'user_post_15_dark_fantasy'
    },
    {
      user_index: 11,
      title: 'Magic & Swords',
      body: 'Learning spells and fighting through a fantasy world is my kind of fun!',
      image: 'user_post_16_fantasy'
    },
    {
      user_index: 12,
      title: 'City Planning',
      body: 'Designing livable cities through simulation games is my passion.',
      image: 'user_post_17_city_planning_simulation'
    },
    {
      user_index: 12,
      title: 'From the Farm',
      body: 'Raising crops and selling them—life sim games give me peace.',
      image: 'user_post_18_cultivation'
    }
  ]

  posts.each do |attrs|
    user_post = UserPost.create!(
      user_id: User.offset(attrs[:user_index]).first.id,
      title: attrs[:title],
      body: attrs[:body]
    )

    image_path = Rails.root.join('app', 'assets', 'images', "#{attrs[:image]}.jpg")
    post.user_post_image.attach(io: File.open(image_path), filename: "#{attrs[:image]}.jpg", 
      content_type: 'image/jpeg')
  end

  # delete_user_posts = [
  #   {
  #     user_index: 10,
  #     title: 'Reflex Challenge',
  #     body: 'Dodging enemy attacks just in time—it’s the ultimate action rush.',
  #     image: 'user_post_13_action'
  #   },



  # ]

  # コールバックを再登録
  UserPost.set_callback(:create, :after, :set_default_user_post_image)

  puts "ユーザー投稿の作成を完了しました"
  puts "ユーザー投稿に対してのコメントの作成を開始しました"

  user_post_comments = [
    # --- 投稿ID 1（user_id:1）---
    { user_id:4, user_post_id:1, body: 'その一手にかける緊張感、わかります！' },
    { user_id:6, user_post_id:1, body: 'チェスは奥が深くて飽きませんよね。' },

    # --- 投稿ID 2（user_id:1）---
    { user_id:5, user_post_id:2, body: '宇宙戦、私も最近ハマってます！' },

    # --- 投稿ID 3（user_id:2）---
    { user_id:6, user_post_id:3, body: 'ナイスブレイク！動画見てみたいです！' },

    # --- 投稿ID 4（user_id:3）---
    # ※コメント無し（user_id:3 はコメント非参加）

    # --- 投稿ID 5（user_id:4）---
    { user_id:1, user_post_id:5, body: '心理戦は勝ったときの快感がたまりませんね。' },

    # --- 投稿ID 6（user_id:4）---
    { user_id:2, user_post_id:6, body: '運任せなところが逆に燃えますよね！' },

    # --- 投稿ID 7（user_id:5）---
    { user_id:6, user_post_id:7, body: '切ない恋って、時々心に残りますよね。' },
    { user_id:7, user_post_id:7, body: '恋愛イベントは泣ける展開が多くて好き！' },
    { user_id:12, user_post_id:7, body: 'I’m learning Japanese through love games too!' },

    # --- 投稿ID 8（user_id:6）---
    { user_id:4, user_post_id:8, body: '怖すぎて途中でやめちゃうことあります笑' },
    { user_id:1, user_post_id:8, body: '夜中にやると夢に出ますよね…' },
    { user_id:11, user_post_id:8, body: 'Love horror too! Got any recommendations?' },

    # --- 投稿ID 9（user_id:6）---
    { user_id:5, user_post_id:9, body: '戦略ゲー好きです！今何やってるんですか？' },

    # --- 投稿ID 10（user_id:7）---
    # ※コメント無し（user_id:7 はコメント非参加）

    # --- 投稿ID 11（user_id:8）---
    { user_id:10, user_post_id:11, body: 'Combos are hard but worth it!' },

    # --- 投稿ID 12（user_id:9）---
    # ※コメント無し（user_id:9 はコメント非参加）

    # --- 投稿ID 13（user_id:9）---
    # ※コメント無し（user_id:9 はコメント非参加）

    # --- 投稿ID 14（user_id:10）---
    { user_id:8, user_post_id:14, body: 'Puzzles make me feel smart too!' },

    # --- 投稿ID 15（user_id:11）---
    { user_id:8, user_post_id:15, body: 'Reflex-based games are the best adrenaline rush.' },

    # --- 投稿ID 16（user_id:11）---
    { user_id:13, user_post_id:16, body: 'Adventure games always take me to another world.' },

    # --- 投稿ID 17（user_id:12）---
    { user_id:8, user_post_id:17, body: 'Dark fantasy is so gripping!' },
    { user_id:10, user_post_id:17, body: 'I love the storytelling in dark fantasy RPGs too!' },
    { user_id:13, user_post_id:17, body: 'I always get lost in those immersive worlds.' },

    # --- 投稿ID 18（user_id:12）---
    { user_id:11, user_post_id:18, body: 'Fantasy RPGs are the best way to escape reality.' },
    { user_id:10, user_post_id:18, body: 'Learning spells is half the fun!' },
    { user_id:13, user_post_id:18, body: 'Same here! Love fighting with swords and magic.' },

    # --- 投稿ID 19（user_id:13）---
    { user_id:8, user_post_id:19, body: 'I play city builders too, what’s your favorite?' },
    { user_id:11, user_post_id:19, body: 'Urban planning games are underrated gems.' },
    { user_id:12, user_post_id:19, body: 'Creating sustainable cities is so satisfying.' },

    # --- 投稿ID 20（user_id:13）---
    { user_id:10, user_post_id:20, body: 'Life sims are such a relaxing break.' },
    { user_id:11, user_post_id:20, body: 'Cultivation games bring me peace too!' },

    # --- 返信例（投稿ID 7, コメントID 7に返信）---
    { user_id:5, user_post_id:7, parent_comment_id:7, body: 'わかります！特に最後の選択肢とか！' },

    # --- 返信例（投稿ID 8, コメントID 10に返信）---
    { user_id:6, user_post_id:8, parent_comment_id:10, body: 'そうですよね。一緒にできるフレンドがいればなぁ...' }
  ]

  user_post_comments.each do |comment_attrs|
    parent_id = comment_attrs.delete(:parent_comment_id)
    comment = UserPostComment.create!(comment_attrs)
    comment.update!(parent_comment_id: parent_id) if parent_id
  end

  puts "ユーザー投稿に対してのコメントの作成を完了しました。"
  puts "管理側ノートの作成を開始します。"

  admin = Admin.find_by(email: admin_email)

  AdminNote.create!([
    {
      admin: admin,
      title: "削除+固定表示",
      body: "これは削除され固定表示されたノートです。",
      is_deleted: true,
      deleted_by_id: admin.id,
      deleted_at: 5.days.ago,
      is_pinned: true,
      created_at: 6.days.ago
    },
    {
      admin: admin,
      title: "削除のみ",
      body: "これは削除されただけのノートです。",
      is_deleted: true,
      deleted_by_id: admin.id,
      deleted_at: 3.days.ago,
      created_at: 4.days.ago
    },
    {
      admin: admin,
      title: "固定表示のみ",
      body: "これは削除されておらず固定表示されているノートです。",
      is_pinned: true,
      created_at: 2.days.ago
    },
    {
      admin: admin,
      title: "フラグなし",
      body: "フラグが立っていないノートです。",
      created_at: 1.days.ago
    },

    # 感謝の気持ちなので直接書くべきか悩みましたがseedにて記載させていただきます
    {
      admin: admin,
      title: "チェックしてくださる皆様へ",
      body: <<~TEXT,
        この度はお忙しい中、ご覧いただき誠にありがとうございます。
        ご不明な点やご質問がございましたら、どうぞお気軽にお知らせください。
      TEXT
      created_at: Time.current
    }
  ])

  puts "管理者ノートの作成を完了しました"
  puts "お知らせの作成を開始します"

  Information.create!([
    {
      admin: admin,
      title: "削除+固定表示+非公開",
      body: "すべてのフラグが立っているお知らせです。",
      is_deleted: true,
      deleted_at: 5.days.ago,
      deleted_by_id: admin.id,
      is_public: false,
      published_at: 9.days.ago,
      is_pinned: true,
      created_at: 10.days.ago
    },
    {
      admin: admin,
      title: "削除+非公開",
      body: "削除かつ非公開のお知らせです。",
      is_deleted: true,
      deleted_at: 3.days.ago,
      deleted_by_id: admin.id,
      is_public: false,
      published_at: 8.days.ago,
      created_at: 9.days.ago
    },
    {
      admin: admin,
      title: "削除+固定表示",
      body: "削除かつ固定表示のお知らせです。",
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      published_at: 6.days.ago,
      is_pinned: true,
      created_at: 7.days.ago
    },
    {
      admin: admin,
      title: "固定表示+非公開",
      body: "固定表示かつ非公開のお知らせです。",
      is_public: false,
      published_at: 5.day.ago,
      is_pinned: true,
      created_at: 5.days.ago
    },
    {
      admin: admin,
      title: "非公開",
      body: "非公開のお知らせです。",
      is_public: false,
      published_at: 3.days.ago,
      created_at: 4.days.ago
    },
    {
      admin: admin,
      title: "固定表示",
      body: "固定表示されているお知らせです。",
      published_at: 1.days.ago,
      is_pinned: true,
      created_at: 2.days.ago
    },
    
    # 固定時の順番の並べ替えを使用(直接表示されるのであえてtitleに入れず、コメントと記載)
    {
      admin: admin,
      title: "皆様へのお知らせ",
      body: <<~TEXT,
        ご訪問いただき誠にありがとうございます。
        当サイトは現在制作途中の為、データが削除される可能性がございます。
        ご利用の際はご留意くださいますよう、何卒よろしくお願い申し上げます。
      TEXT
      published_at: 12.hours.ago,
      sort_order: '0',
      created_at: 12.hours.ago
    },
    {
      admin: admin,
      title: "フラグなし",
      body: <<~TEXT,
        フラグが立っていないノートです。
        seedにて投稿日公開日を入れている投稿に関しては並び替えが適切に変わらない恐れがあります。
      TEXT
      published_at: Time.current,
      created_at: Time.current
    }
  ])

  puts "お知らせをの作成を完了しました"
  puts "seedの実行が完了しました"
end