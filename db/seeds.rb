# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# トランザクションを使用し、エラー時にseedを生成しない(DBのロールバックを行う)
ActiveRecord::Base.transaction do
  # $skip_callbacksはRubyのグローバル変数なので、手動で戻さない場合trueのままなのでbegin、ensureを使用
  begin
    # コールバックのスキップを有効にする
    $skip_callbacks = true

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
      
      # 以降adminを使う箇所があるためここで定義
      admin = Admin.find_by(email: admin_email)

      puts "管理側の作成が完了しました。"
    end

    puts "ユーザーの作成を開始します"

    # 英語・日本語によるユーザーの作成(male、femaleで性別を分け、中性はuser、削除専用はdeleted)
    # ユーザーID:100, 101は削除用、ID:200は非公開用(両方ともユーザー投稿のコメントを作成した後に作成)
    users = [
      {
        email: 'aa@aa',
        password: 'aaaaaa',
        last_name: '鈴木',
        first_name: '太郎',
        nickname: 'すーさん',
        bio: '将棋とチェスが好きで、特に戦略を考えるのが得意です。',
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
        bio: 'カードゲームで頭を使うのが大好きです。運要素が絡むゲームも楽しみます!!',
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

      image_path = Rails.root.join('app', 'assets', 'images', 'user', "#{attrs[:image]}.jpg")
      user.profile_image.attach(io: File.open(image_path), filename: "#{attrs[:image]}.jpg",
        content_type: 'image/jpeg')
    end

    puts "ユーザーの作成が完了しました"
    puts "ユーザー投稿の作成を開始します"

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
        image: 'user_post_16_sf_strategy'
      },
      {
        user_index: 2,
        title: '夜の森を抜けて',
        body: 'サバイバルゲームで無人島を探索。準備が命を分ける！',
        image: 'user_post_5_survival'
      },
      {
        user_index: 3,
        title: '神経戦の日々',
        body: 'トランプゲームでの心理戦がやめられない。いつも全力で挑んでいます。',
        image: 'user_post_2_playing_cards'
      },
      {
        user_index: 4,
        title: '乙女の恋模様',
        body: 'ゲーム内での恋愛シナリオが切なくて胸がきゅんとする。',
        image: 'user_post_3_love_affair'
      },
      {
        user_index: 5,
        title: '深夜の恐怖体験',
        body: 'ホラーゲームの音と演出がリアルすぎて一人でできないレベル。',
        image: 'user_post_4_horror'
      },
      {
        user_index: 5,
        title: '戦術勝負が熱い',
        body: '相手の動きを読んで勝利する戦略ゲームに夢中。',
        image: 'user_post_15_strategy'
      },
      {
        user_index: 6,
        title: '街を駆け抜ける',
        body: 'レースゲームのタイムアタックで自己ベスト更新を目指してます。',
        image: 'user_post_6_racing'
      },
      {
        user_index: 7,
        title: 'Fighting Spirit!',
        body: 'Practicing combos is tough, but the thrill of victory in a match is unbeatable.',
        image: 'user_post_7_fighting_games'
      },
      {
        user_index: 8,
        title: 'Feel the Rhythm',
        body: 'Trying to achieve a full combo on my favorite music game. Love the tempo!',
        image: 'user_post_8_music'
      },
      {
        user_index: 9,
        title: 'Puzzle Joy',
        body: 'There’s nothing like the satisfaction of cracking a tough puzzle.',
        image: 'user_post_9_puzzle'
      },
      {
        user_index: 10,
        title: 'Onward Adventure',
        body: 'Exploring new lands in adventure games always gets me excited.',
        image: 'user_post_10_adventure'
      },
      {
        user_index: 11,
        title: 'Light & Darkness',
        body: 'I adore the world-building in dark fantasy RPGs—so immersive.',
        image: 'user_post_11_dark_fantasy'
      },
      {
        user_index: 11,
        title: 'Magic & Swords',
        body: 'Learning spells and fighting through a fantasy world is my kind of fun!',
        image: 'user_post_12_fantasy'
      },
      {
        user_index: 12,
        title: 'City Planning',
        body: 'Designing livable cities through simulation games is my passion.',
        image: 'user_post_13_city_planning_simulation'
      },
      {
        user_index: 12,
        title: 'From the Farm',
        body: 'Raising crops and selling them—life sim games give me peace.',
        image: 'user_post_14_cultivation'
      }
    ]

    user_posts.each do |attrs|
      user_post = UserPost.create!(
        user_id: User.offset(attrs[:user_index]).first.id,
        title: attrs[:title],
        body: attrs[:body]
      )

      image_path = Rails.root.join('app', 'assets', 'images', 'user_post', "#{attrs[:image]}.jpg")
      user_post.user_post_image.attach(io: File.open(image_path), filename: "#{attrs[:image]}.jpg", 
        content_type: 'image/jpeg')
    end

    puts "ユーザー投稿の作成が完了しました"
    puts "ユーザー投稿に対してのコメントの作成を開始しました"

    user_post_comments = [
      # --- 投稿ID 1(user_id:1)---
      { user_id:4, user_post_id:1, body: 'その一手にかける緊張感、わかります！' },
      { user_id:6, user_post_id:1, body: 'チェスは奥が深くて飽きませんよね。' },

      # --- 投稿ID 2(user_id:1)---
      { user_id:5, user_post_id:2, body: '宇宙戦、私も最近ハマってます！' },

      # --- 投稿ID 3(user_id:2)---
      # ※コメント無し 

      # --- 投稿ID 4(user_id:4)---
      { user_id:1, user_post_id:4, body: '心理戦は勝ったときの快感がたまりませんね。' },      

      # --- 投稿ID 5(user_id:5)---
      { user_id:6, user_post_id:5, body: '切ない恋って、時々心に残りますよね。' },
      { user_id:7, user_post_id:5, body: '恋愛イベントは泣ける展開が多くて好き！' },
      { user_id:12, user_post_id:5, body: 'I’m learning Japanese through love games too!' },

      # --- 投稿ID 6(user_id:6)---
      { user_id:4, user_post_id:6, body: '怖すぎて途中でやめちゃうことあります笑' },
      { user_id:1, user_post_id:6, body: '夜中にやると夢に出ますよね…' },
      { user_id:11, user_post_id:6, body: 'Love horror too! Got any recommendations?' },

      # --- 投稿ID 7(user_id:6)---
      { user_id:5, user_post_id:7, body: '戦略ゲー好きです！今何やってるんですか？' },

      # --- 投稿ID 8(user_id:7)---
      # ※コメント無し

      # --- 投稿ID 9(user_id:8)---
      { user_id:10, user_post_id:9, body: 'Combos are hard but worth it!' },

      # --- 投稿ID 10(user_id:9)---
      # ※コメント無し

      # --- 投稿ID 11(user_id:10)---
      { user_id:8, user_post_id:11, body: 'Puzzles make me feel smart too!' },

      # --- 投稿ID 12(user_id:11)---
      { user_id:13, user_post_id:12, body: 'Adventure games always take me to another world.' },

      # --- 投稿ID 13(user_id:12)---
      { user_id:8, user_post_id:13, body: 'Dark fantasy is so gripping!' },
      { user_id:10, user_post_id:13, body: 'I love the storytelling in dark fantasy RPGs too!' },
      { user_id:13, user_post_id:13, body: 'I always get lost in those immersive worlds.' },

      # --- 投稿ID 14(user_id:12)---
      { user_id:11, user_post_id:14, body: 'Fantasy RPGs are the best way to escape reality.' },
      { user_id:10, user_post_id:14, body: 'Learning spells is half the fun!' },
      { user_id:13, user_post_id:14, body: 'Same here! Love fighting with swords and magic.' },

      # --- 投稿ID 15(user_id:13)---
      { user_id:8, user_post_id:15, body: 'I play city builders too, what’s your favorite?' },
      { user_id:12, user_post_id:15, body: 'Creating sustainable cities is so satisfying.' },

      # --- 投稿ID 16(user_id:13)---
      { user_id:11, user_post_id:16, body: 'Cultivation games bring me peace too!' },
      { user_id:10, user_post_id:16, body: 'Life sims are such a relaxing break.' },

      # --- 返信(投稿ID 5, コメントID 6に返信)---
      { user_id:5, user_post_id:5, parent_comment_id:6, body: 'わかります！特に最後の選択肢とか！' },

      # --- 返信(投稿ID 6,コメントID 10に返信)---
      { user_id:6, user_post_id:6, parent_comment_id:10, body: '最近やったのは「影の館」ってやつです！' }
    ]

    user_post_comments.each do |comment_attrs|
      parent_id = comment_attrs.delete(:parent_comment_id)
      comment = UserPostComment.create!(comment_attrs)
      comment.update!(parent_comment_id: parent_id) if parent_id
    end

    puts "ユーザー投稿に対してのコメントの作成が完了しました。"
    puts "テスト用ユーザーとそれに紐づく投稿・コメントの作成を開始します。"

    # --- 削除関連 ---
    # 削除ユーザー(サイト管理者により削除)
    deleted_user_1 = User.create!(
      id: 100,
      email: 'zz@zz',
      password: 'zzzzzz',
      password_confirmation: 'zzzzzz',
      last_name: '強制退会',
      first_name: 'ユーザー',
      nickname: '強制退会ユーザー',
      bio: '強制退会専用のユーザーです',
      user_status: :banned,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :removed_by_admin
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'user', 'deleted_user_1.jpg')
    deleted_user_1.profile_image.attach(io: File.open(image_path), filename: 'deleted_user_1.jpg', 
      content_type: 'image/jpeg')
    
    # 削除ユーザー(自主退会)
    deleted_user_2 = User.create!(
      id: 101,
      email: 'yy@yy',
      password: 'yyyyyy',
      password_confirmation: 'yyyyyy',
      last_name: '自主退会',
      first_name: 'ユーザー',
      nickname: '自主退会ユーザー',
      bio: '自主退会専用のユーザーです',
      user_status: :deactivated,
      deleted_at: Time.current,
      deleted_by_id: deleted_user_2,
      deleted_reason: :self_deleted
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'user', 'deleted_user_2.jpg')
    deleted_user_2.profile_image.attach(io: File.open(image_path), filename: 'deleted_user_2.jpg', 
      content_type: 'image/jpeg')
    
    # 連鎖削除された投稿とコメント
    delete_user_post_1 = UserPost.create!(
      user_id: deleted_user_1.id,
      title: "#{deleted_user_1.nickname}の投稿(連鎖削除)",
      body: 'ユーザーが強制退会、連鎖削除された投稿です(初期設定でこの投稿が見える場合、問題があります)', 
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :parent_user_deleted,
      deleted_due_to_parent: true
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'user_post', 'deleted_user_post_1_sports.jpg')
    delete_user_post_1.user_post_image.attach(io: File.open(image_path), 
      filename: 'deleted_user_post_1_sports.jpg', content_type: 'image/jpeg')

    UserPostComment.create!(
      user_id:deleted_user_1.id, 
      user_post_id:16, 
      body: 'ユーザーが強制退会、連鎖削除されたコメントです(初期設定でこの内容が見える場合、問題があります)', 
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :parent_user_deleted,
      deleted_due_to_parent: true
    )

    # 自主削除した投稿とコメント
    delete_user_post_2 = UserPost.create!(
      user_id: deleted_user_2.id,
      title: "#{deleted_user_2.nickname}の投稿(自主削除)",
      body: '自主削除した投稿した投稿です(初期設定でこの投稿が見える場合、問題があります)', 
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: deleted_user_2.id,
      deleted_reason: :self_deleted
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'user_post', 'deleted_user_post_2_action.jpg')
    delete_user_post_2.user_post_image.attach(io: File.open(image_path), 
      filename: 'deleted_user_post_2_action.jpg', content_type: 'image/jpeg')

    UserPostComment.create!(
      user_id:deleted_user_2.id, 
      user_post_id:16, 
      body: 'ユーザーが自主削除したコメントです(初期設定でこの内容が見える場合、問題があります)', 
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: deleted_user_2.id,
      deleted_reason: :self_deleted
    )

    # --- 非公開関連 ---
    # 非公開投稿関連データを持つユーザー
    private_user_1 = User.create!(
      id: 200,
      email: 'private@private',
      password: 'aaaaaa',
      password_confirmation: 'aaaaaa',
      last_name: 'テスト用',
      first_name: 'ユーザー',
      nickname: 'テスト用ユーザー',
      bio: <<~TEXT
        皆様に見ていただく際に少しでも内容がわかりやすくなるよう非公開用ユーザーを作成しました。
        関連データは非公開、画像はデフォルト、seed作成直後は最新のIDを持ちます。
      TEXT
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_user.jpg')
    private_user_1.profile_image.attach(io: File.open(image_path), filename: 'no_user.jpg', 
      content_type: 'image/jpeg')

    private_user_post_1 = UserPost.create!(
      user_id: private_user_1.id,
      title: '非公開の投稿',
      body: '非公開の投稿です(初期設定でこの投稿が表示される場合、問題があります)',
      is_public: false
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_user_post.jpg')
    private_user_post_1.user_post_image.attach(io: File.open(image_path), 
      filename: 'no_user_post.jpg', content_type: 'image/jpeg')

    private_user_post_2 = UserPost.create!(
      user_id: private_user_1.id,
      title: '連鎖復元後の非公開の投稿',
      body: '連鎖復元後に非表示処理された投稿です(初期設定でこの投稿が表示される場合、問題があります)',
      hidden_on_parent_restore: true
    )
  
    image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_user_post.jpg')
    private_user_post_2.user_post_image.attach(io: File.open(image_path), 
      filename: 'no_user_post.jpg', content_type: 'image/jpeg')
    
    # 非表示になっているかを確認するために有効な投稿に対してコメントを行なっている
    UserPostComment.create!(
      user_id: private_user_1.id,
      user_post_id: 1, 
      body: '非表示のコメントです(初期設定でこのコメントが表示される場合、問題があります)',
      is_public: false
    )

    UserPostComment.create!(
      user_id: private_user_1.id,
      user_post_id: 1, 
      body: '連鎖復元後に非表示処理されています(初期設定でこのコメントが表示される見える場合、問題があります)',
      hidden_on_parent_restore: true
    )

    puts "テスト用ユーザーとそれに紐づく投稿・コメントの作成が完了しました。"
    puts "グループの作成を開始します。"

    groups = [
      {
        owner_id: 1,
        moderators: [2, 3, 4, 100, 101, 200],
        members: [5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
        name: 'テスト用グループ、タイトル文字数上限２０',
        slug: 'test-group',
        description: <<~TEXT.strip,
          このグループは各種テストのため、グループタイトルやグループ説明を文字数上限まで記\
          載しています。文字数上限ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ
        TEXT
        image: 'group_1'
      },
      {
        owner_id: 8,
        moderators: [],
        members: [14],
        name: 'Low HP, High Vibes',
        slug: 'low-hp-high-vibes',
        description: 'We may not play to win, but we play to feel good. A chill corner for good mood gamers.',
        image: 'group_2'
      },
      {
        owner_id: 1,
        moderators: [],
        members: [2, 7],
        name: 'Campfire Lounge',
        slug: 'campfire-lounge',
        description: '焚き火を囲むような気持ちで、まったりとゲームの話を楽しみましょう。攻略というより、楽しみ方を共有する場所です。',
        image: 'group_3'
      },
      {
        owner_id: 9,
        moderators: [],
        members: [],
        name: 'Melody Quest',
        slug: 'melody-quest',
        description: 'A casual place for rhythm gamers and music lovers to talk scores, games, and groove.',
        image: 'group_4'
      },
      {
        owner_id: 3,
        moderators: [],
        members: [1, 7],
        name: 'ドラゴンの巣調査隊',
        slug: 'dragon-nest',
        description: 'ドラゴンの巣の地図・敵配置・素材集めなどを語る場所です。情報提供歓迎。',
        image: 'group_5'
      },
      {
        owner_id: 14,
        moderators: [],
        members: [],
        name: 'Dog Lovers',
        slug: 'dog-lovers',
        description: 'A chill place for people who love dogs. Share stories, pics, and just say "woof!"',
        image: 'group_6'
      },
      {
        owner_id: 9,
        moderators: [],
        members: [10, 13, 14],
        name: 'EchoStage',
        slug: 'echostage',
        description: 'A virtual stage to talk about rhythm games, game OSTs, and musical adventures.',
        image: 'group_7'
      },
      {
        owner_id: 1,
        moderators: [],
        members: [4, 5, 7],
        name: '初心者ボードゲーム部',
        slug: 'beginner-boardclub',
        description: 'ボードゲーム初心者歓迎。ルールの質問やおすすめも共有しましょう。',
        image: 'group_8'
      },
      {
        owner_id: 13,
        moderators: [9],
        members: [8, 11, 12, 14],
        name: 'The Quiet Grind',
        slug: 'quiet-grind',
        description: 'A group for those who enjoy peaceful farming, crafting, and slow progression games.',
        image: 'group_9'
      },
      {
        owner_id: 5,
        moderators: [1,4,13],
        members: [2, 3, 6, 7, 10, 11, 12, 14],
        name: '夜空カフェ',
        slug: 'yozora-cafe',
        description: '夜の静かな時間、ふと開きたくなるようなゲームの話をここで。ジャンル不問、ほっとする作品の話題歓迎です。',
        image: 'group_10'
      },
      {
        owner_id: 12,
        moderators: [9, 11],
        members: [2, 4, 5, 7, 8, 10, 13, 14],
        name: 'Tavern of Tales',
        slug: 'tavern-of-tales',
        description: 'A cozy guild for sharing fantasy stories, RPG screenshots, and questing tips.',
        image: 'group_11'
      }
    ]
    
    groups.each do |attrs|
      group = Group.create!(
        owner_id: attrs[:owner_id],
        name: attrs[:name],
        slug: attrs[:slug],
        description: attrs[:description],
        created_at: Time.current
      )
    
      image_path = Rails.root.join('app', 'assets', 'images', 'group', "#{attrs[:image]}.jpg")
      group.group_image.attach(io: File.open(image_path), filename: "#{attrs[:image]}.jpg", 
        content_type: 'image/jpeg')
    
      group_members = [{ id: attrs[:owner_id], role: :owner }]
      group_members += Array(attrs[:moderators]).map { |id| { id: id, role: :moderator } }
      group_members += Array(attrs[:members]).map    { |id| { id: id, role: :member } }
    
      group_members.each do |entry|
        GroupMembership.create!(
          group: group,
          user_id: entry[:id],
          member_status: :active, 
          role: entry[:role],
          joined_at: Time.current
        )
      end
    end
    
    puts "グループの作成が完了しました。"
    puts "グループ内お知らせの作成を開始します。"

    long_notice_body = <<~TEXT.strip
      文字数上限まで記載しています。ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
      ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
      ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
      ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
      ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ
    TEXT
    
    group_notices = [
      {
        group_id: 1,
        member_id: 1,
        title: '一番目に作成した非固定お知らせ文字数上限',
        body: long_notice_body
      },
      {
        group_id: 1,
        member_id: 2,
        title: '二番目に作成した固定のお知らせ',
        body: <<~TEXT.strip,
          このお知らせは固定のお知らせの為、優先的に上部に表示されます。また、五行の改行\
          しています。文字数上限まで記載しています。ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ\
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ
        TEXT
        is_pinned: true
      },
      {
        group_id: 1,
        member_id: 3,
        title: '三番目に作成した非固定のお知らせ',
        body: long_notice_body
      },
      {
        group_id: 1,
        member_id: 4,
        title: '四番目に作成した非固定のお知らせ',
        body: long_notice_body
      },
      {
        group_id: 7,
        member_id: 1,
        title: 'Event Cancellation',
        body: 'Unfortunately, the event planned for next month has been canceled due to unforeseen circumstances. Thank you for understanding.'
      },
      {
        group_id: 10,
        member_id: 1,
        title: '投稿マナーについてのお願い',
        body: 'みんなが気持ちよく利用できるよう、投稿の際は誹謗中傷や過度なネガティブコメントを控えていただけると助かります。ご協力よろしくお願いします。'
      },
      {
        group_id: 10,
        member_id: 1,
        title: '新メンバー歓迎会',
        body: '新しく加入したメンバーの歓迎会を開催します。詳細は別途連絡します。'
      },
      {
        group_id: 10,
        member_id: 2,
        title: '過去ログの整理について',
        body: '掲示板の過去の投稿を月末に一部整理します。必要な内容は保存してください。'
      },
      {
        group_id: 11,
        member_id: 2,
        title: 'Spoiler Warning',
        body: 'Please use spoiler tags or warnings when discussing recent events or endings. Let’s keep it fun for everyone!'
      },
      {
        group_id: 11,
        member_id: 3,
        title: 'Share Your Tips!',
        body: "If you know handy tricks, shortcuts, or little secrets, please share them with the group! Let's help each other and make the community more fun and active together.",
      },
      {
        group_id: 11,
        member_id: 3,
        title: 'Login Posts Banned',
        body: "Posts like “I logged in” are discouraged. Please share something meaningful to keep the group engaging."
      }
    ]

    group_notices.each do |attrs|
      # グループを取得
      group = Group.find(attrs[:group_id])

      # group内のメンバーの配列を作り、attrs[:member_id]で何番目かを指定(登録順でソート)
      memberships = group.group_memberships.order(:id)
    
      # attrs[:member_id]を1始まりの番号とすると、配列は0始まりなので-1する
      target_membership = memberships[attrs[:member_id] - 1]
    
      # member_idを正しいGroupMembership.idに置き換え
      attrs[:member_id] = target_membership.id

      GroupNotice.create!(attrs)
    end

    puts "グループ内お知らせの作成が完了しました。"
    puts "グループ内イベントの作成を開始します。"

    group_events = [
      {
        group_id: 1,
        member_id: 1,
        title: '一番目に作成したイベント文字数上限ＸＸＸ',
        description: <<~TEXT.strip,
          イベントは開始予定日時が近いものから順番に並びます。また、終了予定日時を過ぎると\
          管理権限があるメンバーにのみ表示されます。文字数上限まで記載しています。ＸＸＸＸ\
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ
        TEXT
        start_time: Time.current + 2.months + 1.day,
        end_time: Time.current + 2.months + 1.day + 1.hours
      },
      {
        group_id: 1,
        member_id: 8,
        title: '二番目に作成したイベント文字数上限ＸＸＸ',
        description: <<~TEXT,
          五行の改行しています。文字数上限まで記
          載しています。ＸＸＸＸＸＸＸＸＸＸＸＸ
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ
        TEXT
        start_time: Time.current + 2.months + 3.days,
        end_time: Time.current + 2.months + 3.days + 2.hours
      },
      {
        group_id: 1,
        member_id: 8,
        title: '三番目に作成したイベント文字数上限ＸＸＸ',
        description: <<~TEXT,
          この投稿と2番目に作成した投稿は同じ投稿者で管理者権限のないメンバーです
          イベントは管理権限がなくても作成可能
          二番目に作成したイベントよりも早く開催するように設定してあります
        TEXT
        start_time: Time.current + 2.months + 2.day,
        end_time: Time.current + 2.months + 2.day + 2.hours
      },
      {
        group_id: 1,
        member_id: 3,
        title: '四番目に作成したイベント文字数上限ＸＸＸ',
        description: <<~TEXT,
          五番目のイベントは既に終了しているので管理権限があるメンバーしか見えない
        TEXT
        start_time: Time.current + 2.months + 4.day,
        end_time: Time.current + 2.months + 4.day + 4.hours
      },
      {
        group_id: 1,
        member_id: 3,
        title: '五番目に作成したイベント文字数上限ＸＸＸ',
        description: <<~TEXT,
          このイベントはすでに終了しているので管理権限のあるメンバーにしか見えてはいけない
        TEXT
        start_time: Time.current - 1.day,
        end_time: Time.current - 1.day
      },
      {
        group_id: 10,
        member_id: 1,
        title: '世界観研究読書会',
        description: '設定資料や小説版を読んで、背景世界について語り合いましょう。',
        start_time: Time.current + 2.months + 1.day,
        end_time: Time.current + 2.months + 1.day + 2.hours
      },
      {
        group_id: 10,
        member_id: 1,
        title: '雑談だけの夜',
        description: 'ゲームから離れて、たまには雑談だけで盛り上がる夜を楽しみましょう。お菓子持参歓迎！',
        start_time: Time.current + 2.months + 2.day,
        end_time: Time.current + 2.months + 2.day + 3.hours
      },
      {
        group_id: 10,
        member_id: 5,
        title: 'ゲーム小話シェア会',
        description: 'ゲームの裏話や面白エピソードを気軽に語り合う会です。堅苦しくなく、リラックスしてご参加ください。',
        start_time: Time.current + 2.months + 9.days,
        end_time: Time.current + 2.months + 9.days + 2.hours
      },
      {
        group_id: 11,
        member_id: 3,
        title: 'Beginner Build Tips',
        description: 'Learn the basics of gear and skill selection for character building. Perfect for new players.',
        start_time: Time.current + 2.months + 6.days,
        end_time: Time.current + 2.months + 6.days + 2.hours
      },
      {
        group_id: 11,
        member_id: 1,
        title: 'Endurance Raid Run',
        description: 'Join us in a limited-time high-difficulty raid! Team up and come well prepared for battle!',
        start_time: Time.current + 2.months + 7.days,
        end_time: Time.current + 2.months + 9.days
      },
      {
        group_id: 11,
        member_id: 8,
        title: 'Pre-Tourney Practice',
        description: 'Get ready for next month’s official tournament with full-on mock battle sessions!',
        start_time: Time.current + 2.months + 10.days,
        end_time: Time.current + 2.months + 10.days + 5.hours
      }
    ]
    
    group_events.each do |attrs|
      # グループを取得
      group = Group.find(attrs[:group_id])

      # group内のメンバーの配列を作り、attrs[:member_id]で何番目かを指定(登録順でソート)
      memberships = group.group_memberships.order(:id)
    
      # attrs[:member_id]を1始まりの番号とすると、配列は0始まりなので-1する
      target_membership = memberships[attrs[:member_id] - 1]
    
      # member_idを正しいGroupMembership.idに置き換え
      attrs[:member_id] = target_membership.id

      GroupEvent.create!(attrs)
    end

    puts "グループ内イベントの作成が完了しました。"
    puts "グループ内投稿の作成を開始します。"

    group_posts = [
      {
        group_id: 1,
        member_id: 1,
        title: 'グループ内投稿テスト用文字数上限２０文字',
        body: <<~TEXT,
          コメントは連鎖削除、自主削除、非公開のパ
          ラメーターで投稿しています。この投稿は五
          行での改行（一行二十文字）、文字数上限で
          投稿を作成しています。ＸＸＸＸＸＸＸＸＸ
          ＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸＸ
        TEXT
        image: 'group_post_1',
        visible: false
      },
      {
        group_id: 6,
        member_id: 1,
        title: 'Pet Talent Contest',
        body: "My dog's amazing at jumping! If your pet has cool skills, in-game or real life, please share. Join the group and let's talk!",
        image: 'group_post_2',
        visible: true
      },
      {
        group_id: 7,
        member_id: 1,
        title: 'Favorite BGM Poll',
        body: "Share your favorite game BGM! From battle themes to relaxing tunes, all are welcome. Let's discover great music together!",
        image: 'group_post_3',
        visible: false
      },
      {
        group_id: 8,
        member_id: 1,
        title: 'オンライン対戦で気をつけてること',
        body: '時間切れしやすい人は、序盤の手はパターン化しておくと集中力が持続します。あとチャットは短く！',
        image: 'group_post_4',
        visible: false
      },
      {
        group_id: 9,
        member_id: 1,
        title: 'Recommended Auto',
        body: 'Arrange small sprinklers, tillers, and harvest robots in that order. By morning, your farm will be perfectly maintained—ideal for efficiency lovers!',
        image: 'group_post_5',
        visible: false
      },
      {
        group_id: 10,
        member_id: 2,
        title: '初プレイ体験談',
        body: 'ゲームを始めたばかりの頃の思い出や苦労話を語り合いましょう。初心者歓迎です。',
        image: 'group_post_6',
        visible: false
      },
      {
        group_id: 10,
        member_id: 1,
        title: '幻の絶景スポット発見',
        body: '「銀嶺の谷」にある隠れ滝は朝日が当たると虹がかかり幻想的です。探索ルートが複雑なので地図片手に挑戦を！',
        image: 'group_post_7',
        visible: true
      },
      {
        group_id: 10,
        member_id: 6,
        title: '珍しいモンスターの生態',
        body: '「影歩きゴブリン」は日中は動かず夜になると活発化。見つけたら戦うより観察がおすすめです。',
        image: 'group_post_8',
        visible: true
      },
      {
        group_id: 11,
        member_id: 7,
        title: '敵戦艦の魅力',
        body: '最新DLCの敵戦艦は独特の曲線デザインで美しい。撃破時の演出も凝っていてファンアートが増えてます。',
        image: 'group_post_9',
        visible: false
      },
      {
        group_id: 11,
        member_id: 8,
        title: 'Best Ctrl Setup',
        body: 'Swapping dodge and jump buttons drastically reduced my damage taken. Once used to it, combat becomes much easier and smoother.',
        image: 'group_post_10',
        visible: false
      },
      {
        group_id: 11,
        member_id: 1,
        title: 'Phase 3 Boss Move',
        body: 'When HP falls below 30%, the boss unleashes an instant-kill attack on all. Stack buffs or use shields beforehand to survive.',
        image: 'group_post_11',
        visible: true
      },
      {
        group_id: 11,
        member_id: 2,
        title: 'Guide Differences',
        body: "Some guides say a 'hidden boss' appears in area 4, but it's actually random and often doesn't show up in every playthrough.",
        image: 'group_post_12',
        visible: false
      }
    ]
    
    group_posts.each do |attrs|
      group = Group.find(attrs[:group_id])

      # group内のメンバーの配列を作り、attrs[:member_id]で何番目かを指定(登録順でソート)
      memberships = group.group_memberships.order(:id)
      
      # attrs[:member_id]を1始まりの番号とすると、配列は0始まりなので-1する
      target_membership = memberships[attrs[:member_id] - 1]
    
      group_post = GroupPost.create!(
        group_id: group.id,
        member_id: target_membership.id,
        title: attrs[:title],
        body: attrs[:body]
      )
    
      image_path = Rails.root.join('app', 'assets', 'images', 'group_post', "#{attrs[:image]}.jpg")
      group_post.group_post_image.attach(io: File.open(image_path), filename: "#{attrs[:image]}.jpg",
        content_type: 'image/jpeg')

      # トップページの"最新のグループ内投稿"の上限値を満たさないように4件のみに定義
      if attrs[:visible]
        group_post.update!(visible_to_non_members: true)
      end

      # 投稿が行われたグループのlast_posted_atを更新
      group = Group.find(attrs[:group_id])
      group.update!(last_posted_at: group_post.created_at)
    end

    puts "グループ内投稿の作成が完了しました。"
    puts "グループ内投稿に対してのコメントの作成を開始します。"

    group_post_comments = [
      # --- 投稿ID 1 ---
      { group_post_id: 1, member_id: 1, body: 'テスト用、削除済みと非公開の子コメントが紐づいている' },
      # その他にも削除済み、非公開を次のセッションで追加している

      # --- 投稿ID 2 ---
      # ※コメント無し

      # --- 投稿ID 3 ---
      # ※コメント無し

      # --- 投稿ID 4 --- 
      # ※コメント無し 

      # --- 投稿ID 5 ---
      { group_post_id: 5, member_id: 5, body: 'Nice!! Now I can sleep soundly lol.' },

      # --- 投稿ID 6 ---
      { group_post_id: 6, member_id: 5, body: 'クエストの目的がよく理解できなくて困りました。' },
      { group_post_id: 6, member_id: 2, body: '最初のボス戦で何度もやり直しました。' },

      # --- 投稿ID 7 ---
      { group_post_id: 7, member_id: 5, body: '隠れ滝の虹、本当に綺麗で感動しました！' },
      { group_post_id: 7, member_id: 3, body: '地図がないと迷ってしまう難しさですね。' },
      { group_post_id: 7, member_id: 9, body: 'This view is unbelievably beautiful!' },

      # --- 投稿ID 8 ---
      # ※コメント無し

      # --- 投稿ID 9 ---
      { group_post_id: 9, member_id: 11, body: 'Haha, even my Japanese friend gets it!' },

      # --- 投稿ID 10 ---
      { group_post_id: 10, member_id: 2, body: 'Hard to learn, but yeah, this is great.' },

      # --- 投稿ID 11 ---
      { group_post_id: 11, member_id: 2, body: 'The real fight begins below 30% HP.' },
      { group_post_id: 11, member_id: 9, body: 'I got nuked so fast, I blinked and died!' },

      # --- 投稿ID 12 ---
      # ※コメント無し

      # --- 返信(投稿ID 6, コメントID 3,4に返信)---
      { group_post_id: 6, member_id: 1, parent_comment_id: 3, body: '私もよくあります。行先を間違えてしまったことも...' },
      { group_post_id: 6, member_id: 1, parent_comment_id: 4, body: '操作に慣れてない時のボス戦は大変ですよね!!' },

      # --- 返信(投稿ID 7, コメントID 5, 6, 7に返信)---
      { group_post_id: 7, member_id: 7, parent_comment_id: 5, body: '幻想的な滝の景色に癒されました。' },
      { group_post_id: 7, member_id: 3, parent_comment_id: 5, body: '朝日に照らされる虹の美しさに感動！' },
      { group_post_id: 7, member_id: 1, parent_comment_id: 6, body: 'その分とても見ごたえがありますよね!!' },
      { group_post_id: 7, member_id: 4, parent_comment_id: 7, body: 'I saw it too, and it was truly stunning.' },
      { group_post_id: 7, member_id: 1, parent_comment_id: 7, body: 'はい、とてもきれいな私の一押しスポットです!!' },
      
      # --- 返信(投稿ID 11, コメントID 11に返信)---
      { group_post_id: 11, member_id: 8, parent_comment_id: 11, body: 'Buffs or die. No in-between.' },
      { group_post_id: 11, member_id: 7, parent_comment_id: 11, body: '海外のゲームは特に難しい' },
      { group_post_id: 11, member_id: 11, parent_comment_id: 11, body: 'Jesus!!! That explosion got me again!' },
      { group_post_id: 11, member_id: 1, parent_comment_id: 11, body: 'Laughed so hard when we all flew into the air!' },
    ]

    group_post_comments.each do |attrs|
      # 投稿に紐づくグループを取得
      group_post = GroupPost.find(attrs[:group_post_id])
      group = group_post.group

      # group内のメンバーの配列を作り、attrs[:member_id]で何番目かを指定(登録順でソート)
      memberships = group.group_memberships.order(:id)
    
      # attrs[:member_id]を1始まりの番号とすると、配列は0始まりなので-1する
      target_membership = memberships[attrs[:member_id] - 1]
    
      # member_idを正しいGroupMembership.idに置き換え
      attrs[:member_id] = target_membership.id
    
      # parent_comment_id(子コメント)を一旦除外して後から設定
      parent_id = attrs.delete(:parent_comment_id)
    
      # コメント作成
      comment = GroupPostComment.create!(attrs)
    
      # 親コメントの設定
      comment.update!(parent_comment_id: parent_id) if parent_id
    end    

    puts "グループ内投稿に対してのコメントの作成が完了しました。"
    puts "グループ機能のテスト用ユーザーの更新とデータの作成を開始します。"
    
    # --- 削除関連 ---
    # 連鎖削除されたグループ内のお知らせ・イベント・投稿・コメント
    delete_group_notice_1 = GroupNotice.create!(
      group_id: 1,
      member_id: 5,
      title: '強制退会により、連鎖削除されたお知らせ',
      body: 'ユーザーが強制退会、連鎖削除されたお知らせです(初期設定でこのお知らせが見える場合、問題があります)', 
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :parent_user_deleted,
      deleted_due_to_parent: true
    )

    delete_group_event_1 = GroupEvent.create!(
      group_id: 1,
      member_id: 5,
      title: '強制退会により、連鎖削除されたイベント',
      description: 'ユーザーが強制退会、連鎖削除されたイベントです(初期設定でこのイベントが見える場合、問題があります)', 
      start_time: Time.current + 2.months,
      end_time: Time.current + 2.months + 1.day,
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :parent_user_deleted,
      deleted_due_to_parent: true
    )

    delete_group_post_1 = GroupPost.create!(
      group_id: 1,
      member_id: 5,
      title: '強制退会により、連鎖削除された投稿',
      body: 'ユーザーが強制退会、連鎖削除された投稿です(初期設定でこの投稿が見える場合、問題があります)',
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :parent_user_deleted,
      deleted_due_to_parent: true
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'group_post', 'deleted_gropu_post_1_billiards.jpg')
    delete_group_post_1.group_post_image.attach(io: File.open(image_path), 
      filename: 'no_group_post.jpg', content_type: 'image/jpeg')

    delete_group_post_comment_1 = GroupPostComment.create!(
      group_post_id: 1,
      member_id: 5,
      body: 'ユーザーが強制退会、連鎖削除されたコメントです(初期設定でこの内容が見える場合、問題があります)',
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :parent_user_deleted,
      deleted_due_to_parent: true
    )

    delete_group_post_comment_2 = GroupPostComment.create!(
      group_post_id: 1,
      member_id: 5,
      parent_comment_id: 1,
      body: 'ユーザーが強制退会、連鎖削除された子コメントです(初期設定でこの内容が見える場合、問題があります)',
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :parent_user_deleted,
      deleted_due_to_parent: true
    )

    # 自主削除したグループ内のお知らせ・イベント・投稿・コメント
    delete_group_notice_2 = GroupNotice.create!(
      group_id: 1,
      member_id: 6,
      title: '自主削除したお知らせ',
      body: 'ユーザーが自主削除したお知らせ(初期設定でこのお知らせが見える場合、問題があります)', 
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: 6,
      deleted_reason: :self_deleted
    )

    delete_group_event_2 = GroupEvent.create!(
      group_id: 1,
      member_id: 6,
      title: '自主削除したイベント',
      description: 'ユーザーが自主削除したイベント(初期設定でこのイベントが見える場合、問題があります)', 
      start_time: Time.current + 3.months,
      end_time: Time.current + 3.months + 1.day,
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: 6,
      deleted_reason: :self_deleted
    )

    delete_group_post_2 = GroupPost.create!(
      group_id: 1,
      member_id: 6,
      title: '自主削除した投稿',
      body: 'ユーザーが自主削除した投稿です(初期設定でこの投稿が見える場合、問題があります)',
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: 6,
      deleted_reason: :self_deleted
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'group_post', 'deleted_gropu_post_2_dice.jpg')
    delete_group_post_2.group_post_image.attach(io: File.open(image_path), 
      filename: 'no_group_post.jpg', content_type: 'image/jpeg')

    delete_group_post_comment_3 = GroupPostComment.create!(
      group_post_id: 1,
      member_id: 6,
      body: 'ユーザーが自主削除したコメントです(初期設定でこの内容が見える場合、問題があります)',
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: 6,
      deleted_reason: :self_deleted
    )

    delete_group_post_comment_4 = GroupPostComment.create!(
      group_post_id: 1,
      member_id: 6,
      parent_comment_id: 1,
      body: 'ユーザーが自主削除した子コメントです(初期設定でこの内容が見える場合、問題があります)',
      is_deleted: true,
      deleted_at: Time.current,
      deleted_by_id: 6,
      deleted_reason: :self_deleted
    )

    # --- 非公開関連 ---
    # 非公開のグループ内お知らせ・イベント・投稿・コメント
    private__group_notice_1 = GroupNotice.create!(
      group_id: 1,
      member_id: 7,
      title: '非公開のお知らせ',
      body: '非公開のお知らせ(初期設定でこのお知らせが見える場合、問題があります)', 
      is_public: false
    )

    private__group_notice_2 = GroupNotice.create!(
      group_id: 1,
      member_id: 7,
      title: '連鎖復元後の非公開のお知らせ',
      body: '連鎖復元後に非表示処理されたお知らせ(初期設定でこのお知らせが見える場合、問題があります)', 
      hidden_on_parent_restore: true
    )

    private_group_event_1 = GroupEvent.create!(
      group_id: 1,
      member_id: 7,
      title: '非公開のイベント',
      description: '非公開のイベント(初期設定でこのイベントが見える場合、問題があります)', 
      start_time: Time.current + 4.months,
      end_time: Time.current + 4.months + 1.day,
      is_public: false
    )

    private_group_event_2 = GroupEvent.create!(
      group_id: 1,
      member_id: 7,
      title: '連鎖復元後の非公開のイベント',
      description: '連鎖復元後に非表示処理された非公開のイベント(初期設定でこのイベントが見える場合、問題があります)', 
      start_time: Time.current + 5.months,
      end_time: Time.current + 5.months + 1.day,
      hidden_on_parent_restore: true
    )

    # 投稿
    private_group_post_1 = GroupPost.create!(
      group_id: 1,
      member_id: 7,
      title: '非公開の投稿',
      body: '非公開の投稿です(初期設定でこの投稿が見える場合、問題があります)',
      is_public: false
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_group_post.jpg')
    private_group_post_1.group_post_image.attach(io: File.open(image_path), 
      filename: 'no_group_post.jpg', content_type: 'image/jpeg')

    private_group_post_2 = GroupPost.create!(
      group_id: 1,
      member_id: 7,
      title: '外部への公開設定をした非公開の投稿',
      body: '外部への公開設定を行っているが非公開の投稿です(初期設定でこの投稿が見える場合、問題があります)',
      is_public: false,
      visible_to_non_members: true
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_group_post.jpg')
    private_group_post_2.group_post_image.attach(io: File.open(image_path), 
      filename: 'no_group_post.jpg', content_type: 'image/jpeg')

    private_group_post_3 = GroupPost.create!(
      group_id: 1,
      member_id: 7,
      title: '連鎖復元後の非公開の投稿',
      body: '連鎖復元後に非表示処理された投稿です(初期設定でこの投稿が見える場合、問題があります)',
      hidden_on_parent_restore: true
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_group_post.jpg')
    private_group_post_3.group_post_image.attach(io: File.open(image_path), 
      filename: 'no_group_post.jpg', content_type: 'image/jpeg')

    private_group_post_4 = GroupPost.create!(
      group_id: 1,
      member_id: 7,
      title: '外部への公開設定をした連鎖復元後の投稿',
      body: '外部への公開設定を行っているが連鎖復元後に非表示処理された投稿です(初期設定でこの投稿が見える場合、問題があります)',
      hidden_on_parent_restore: true,
      visible_to_non_members: true
    )

    image_path = Rails.root.join('app', 'assets', 'images', 'no_image', 'no_group_post.jpg')
    private_group_post_4.group_post_image.attach(io: File.open(image_path), 
      filename: 'no_group_post.jpg', content_type: 'image/jpeg')

    # コメント(すべて同じグループ内にある非表示なっていない投稿にコメントを行っている)
    private_group_post_comment_1 = GroupPostComment.create!(
      group_post_id: 1,
      member_id: 7,
      body: '非公開のコメントです(初期設定でこの内容が見える場合、問題があります)',
      is_public: false
    )

    private_group_post_comment_2 = GroupPostComment.create!(
      group_post_id: 1,
      member_id: 7,
      body: '連鎖復元後に非表示処理されたコメントです(初期設定でこの内容が見える場合、問題があります)',
      hidden_on_parent_restore: true
    )

    private_group_post_comment_3 = GroupPostComment.create!(
      group_post_id: 1,
      member_id: 7,
      parent_comment_id: 1,
      body: '非公開の子コメントです(初期設定でこの内容が見える場合、問題があります)',
      is_public: false
    )

    private_group_post_comment_4 = GroupPostComment.create!(
      group_post_id: 1,
      member_id: 7,
      parent_comment_id: 1,
      body: '連鎖復元後に非表示処理された子コメントです(初期設定でこの内容が見える場合、問題があります)',
      hidden_on_parent_restore: true
    )

    # 削除用、非公開用のユーザーデータの更新
    # 連鎖削除の再現
    GroupMembership.where(user_id: 100, group_id: 1).update_all(
      member_status: GroupMembership.member_statuses[:inactive],
      deleted_at: Time.current,
      deleted_by_id: admin.id,
      deleted_reason: :parent_group_deleted,
      deleted_due_to_parent: true
    )

    # 自主脱退の再現
    GroupMembership.where(user_id: 101, group_id: 1).update_all(
      member_status: GroupMembership.member_statuses[:inactive],
      deleted_at: Time.current,
      deleted_by_id: deleted_user_2.id,
      deleted_reason: :voluntarily_left_group
    )

    # テスト用非公開ユーザー
    GroupMembership.where(user_id: 200, group_id: 1).update_all(is_public: false)

    puts "グループ機能のテスト用ユーザーの更新とデータの作成が完了しました。"
    puts "管理側ノートの作成を開始します。"

    AdminNote.create!([
      {
        admin: admin,
        title: '削除+固定表示',
        body: 'これは削除され固定表示されたノートです。',
        is_deleted: true,
        deleted_by_id: admin.id,
        deleted_at: 5.days.ago,
        is_pinned: true,
        created_at: 6.days.ago
      },
      {
        admin: admin,
        title: '削除のみ',
        body: 'これは削除されただけのノートです。',
        is_deleted: true,
        deleted_by_id: admin.id,
        deleted_at: 3.days.ago,
        created_at: 4.days.ago
      },
      {
        admin: admin,
        title: '固定表示のみ',
        body: 'これは削除されておらず固定表示されているノートです。',
        is_pinned: true,
        created_at: 2.days.ago
      },
      {
        admin: admin,
        title: 'フラグなし',
        body: 'フラグが立っていないノートです。',
        created_at: 1.days.ago
      },

      # 感謝の気持ちなので直接書くべきか悩みましたがseedにて記載させていただきます
      {
        admin: admin,
        title: 'チェックしてくださる皆様へ',
        body: <<~TEXT,
          この度はお忙しい中、ご覧いただき誠にありがとうございます。
          ご不明な点やご質問がございましたら、どうぞお気軽にお知らせください。
        TEXT
        is_pinned: true,
        created_at: Time.current
      }
    ])

    puts "管理者ノートの作成が完了しました"
    puts "お知らせの作成を開始します"

    Information.create!([
      {
        admin: admin,
        title: '削除+固定表示+非公開',
        body: 'すべてのフラグが立っているお知らせです。',
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
        title: '削除+非公開',
        body: '削除かつ非公開のお知らせです。',
        is_deleted: true,
        deleted_at: 3.days.ago,
        deleted_by_id: admin.id,
        is_public: false,
        published_at: 8.days.ago,
        created_at: 9.days.ago
      },
      {
        admin: admin,
        title: '削除+固定表示',
        body: '削除かつ固定表示のお知らせです。',
        is_deleted: true,
        deleted_at: Time.current,
        deleted_by_id: admin.id,
        published_at: 6.days.ago,
        is_pinned: true,
        created_at: 7.days.ago
      },
      {
        admin: admin,
        title: '固定表示+非公開',
        body: '固定表示かつ非公開のお知らせです。',
        is_public: false,
        published_at: 5.day.ago,
        is_pinned: true,
        created_at: 5.days.ago
      },
      {
        admin: admin,
        title: '非公開',
        body: '非公開のお知らせです。',
        is_public: false,
        published_at: 3.days.ago,
        created_at: 4.days.ago
      },
      {
        admin: admin,
        title: '固定表示',
        body: '固定表示されているお知らせです。',
        published_at: 1.days.ago,
        is_pinned: true,
        created_at: 2.days.ago
      },
      
      # 固定時の順番の並べ替えを使用(直接表示されるのであえてtitleに入れず、コメントと記載)
      {
        admin: admin,
        title: '皆様へのお知らせ',
        body: <<~TEXT,
          ご訪問いただき誠にありがとうございます。
          当サイトは現在制作途中の為、データが削除される可能性がございます。
          ご利用の際はご留意くださいますよう、何卒よろしくお願い申し上げます。
        TEXT
        published_at: 12.hours.ago,
        sort_order: 0,
        is_pinned: true,
        created_at: 12.hours.ago
      },
      {
        admin: admin,
        title: 'フラグなし',
        body: <<~TEXT,
          フラグが立っていないノートです。
          seedにて投稿日公開日を入れている投稿に関しては並び替えが適切に変わらない恐れがあります。
        TEXT
        published_at: Time.current,
        created_at: Time.current
      }
    ])

    puts "お知らせをの作成が完了しました"
    puts "seedの実行が完了しました"

  ensure
    # コールバックのスキップを無効にする
    $skip_callbacks = false
  end
end