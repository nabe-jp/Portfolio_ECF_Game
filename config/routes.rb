Rails.application.routes.draw do
  namespace :admin do
    get 'messages/destroy'
  end
  namespace :admin do
    get 'dm_rooms/index'
    get 'dm_rooms/show'
    get 'dm_rooms/destroy'
  end
  namespace :admin do
    get 'group_post_comments/destroy'
  end
  namespace :admin do
    get 'group_posts/index'
    get 'group_posts/show'
    get 'group_posts/destroy'
  end
  namespace :admin do
    get 'groups/index'
    get 'groups/show'
    get 'groups/destroy'
  end
  namespace :admin do
    get 'user_post_comments/destroy'
  end
  namespace :admin do
    get 'user_posts/index'
    get 'user_posts/show'
    get 'user_posts/destroy'
  end
  namespace :admin do
    get 'users/index'
    get 'users/show'
    get 'users/update'
  end
  # ネストが深くなると可読性、保守性が下がるので命名を短くしました
  # その為、同じ名前が出てくるのでパスプレフィックス(/users, /groups)にてルートを分けています

  # 会員側
  devise_for :users, skip: [:passwords, :cancel], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # 管理者側
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # 検索機能
  resources :searches, only: [:index]

  # 会員用ルーティング
  scope module: :public do
    root to: "homes#top"
    get 'about', to: 'homes#about'

    # マイページは個人情報を取り扱い、自分の設定の変更はほかのユーザーはしないのでidを持たないように設計
    # usersを作成しているためこのままではusersのコントローラーを使用するのでcontrollerを設定
    # :idは付きませんがユーザーに対する操作であることを明示的にするためにmemberを使用しています
    resource :user, only: [:show, :edit, :update], controller: 'user' do
      member do
        get 'mypage'
        get 'settings'
        get 'check'
        patch 'withdraw'
      end
    end
    
    # showはresource_userにもあるのでuser_post_pathに配置される、そこでは衝突が起こるのでpathを設定しています
    # リソースフルにするために投稿はresource_userにネストせずresources_usersにネストしました
    resources :users, only: [] do
      member do
        get 'show', as: 'show'
      end
      resources :user_posts, only: [:index, :show, :new, :create, :edit, :update, :destroy], 
        path: "posts", as: "posts" do
        resources :user_post_comments, only: [:create, :destroy], path: "comments", as: "comments"
      end
    end

    # ユーザーの全投稿用(indexだけのためresourcesは使用せずカスタム)
    # 将来の拡張性を考えpublic側とadmin側に分ける設計を行いました
    get 'users/posts', to: 'user_posts#index', as: 'user_all_posts'

    # 他の会員用ルーティング
  end

  # 管理者用ルーティング
  namespace :admin do
    root to: "dashboard#top"
  
    # 管理者への申し送りなどの記載に使用するために設置
    resources :admin_notes, only: [:edit, :update], path: "notes", as: "notes"

    # ユーザーへのニュースやお知らせ
    resources :informations, only: [:edit, :update], path: "posts", as: "posts"

    resources :user_posts, only: [:show, :destroy] do
      resources :user_post_comments, only: [:destroy], path: "comments", as: "comments"
    end
  
    # ユーザー管理
    resources :users, only: [:index, :show, :update] do
      member do
        patch 'deactivate'   # 凍結や強制退会等
        patch 'reactivate'   # 再開
      end
    end

    # 投稿管理(全ユーザーの投稿を一覧・閲覧・削除など)
    get 'users/posts', to: 'user_posts#index', as: 'user_all_posts'
  
    # グループ機能(今後予定)
    resources :groups, only: [:index, :show, :destroy] do
      resources :group_posts, only: [:index, :show, :destroy], path: "posts", as: "posts" do
        resources :group_post_comments, only: [:destroy], path: "comments", as: "comments"
      end
    end
  
    # DM機能(フレンド同士)
    resources :dm_rooms, only: [:index, :show, :destroy] do
      resources :messages, only: [:destroy]
    end
  
    # その他の管理用ツール
    get 'button/test', to: 'button#test', as: 'button_test'
  end
end  