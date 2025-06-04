Rails.application.routes.draw do
  # ネストによるヘルパー名やURLの冗長性を抑え、可読性を意識したルーティング設計
  # as:はURLヘルパー名として使われるのでシンボルに、path: は実際のルーティングURL文字列になるので文字列で記載

  # 会員側
  devise_for :users, skip: [:passwords, :cancel], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  # 管理者側
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  # 会員用ルーティング
  scope module: :public do
    root to: 'homes#top'
    get 'about', to: 'homes#about'

    # 検索機能
    resources :searches, only: [:index]

    # ユーザーの全投稿用(indexだけのためresourcesは不使用、全表示の為トップレベルに配置)
    get 'users/posts', to: 'all_user_posts#index', as: :user_all_posts

    # 自身のものを取り扱う(個人情報なども含まれている)のでidを持たないように設計
    # usersを作成しているためこのままではusersのコントローラーを使用するのでcontrollerを設定
    # :idは付きませんがユーザーに対する操作であることを明示的にするためにmemberを使用
    resource :user, only: [:show, :edit, :update], controller: :user do
      member do
        get :mypage
        get :settings
        get :check
        patch :withdraw
      end
    end

    # showはresource_userにもあるのでそのまま使用するとuser_post_pathに配置され衝突が起こる
    # resource_usersにasを使用するとネストにも影響を与えるため、only: []、memberに配置しasを使用しpathを設定
    # リソースフルにするために投稿はresource_userにネストせずresources_usersにネスト
    resources :users, only: [] do
      member do
        get :show, as: :show
      end
      resources :user_posts, path: 'posts', as: :posts, module: :users do
        resources :user_post_comments, only: [:create, :destroy], path: 'comments', 
          as: :comments, module: :users
      end
    end
    
    # 自分が所属しているグループ一覧 を表示する機能(責務を混ぜず、IDも必要ないので独立ルート)
    get 'my_groups', to: 'groups#my_groups'

    # スラッグを使用
    resources :groups, param: :slug do
      member do
        post :join                # 参加する
        delete :leave             # 退出する
      end

      # グループメンバーの専用ページ
      # dashboardはこのままでは複数形のコントローラーが使用されるので単数形を使用するように変更
      scope module: :groups do
        resource :group_dashboard, only: [:show], path: 'dashboard', as: :dashboard, 
          controller: 'group_dashboard'

        resources :group_events, path: 'events', as: :events
        resources :group_notices, path: 'notices', as: :notices
        resources :group_members, only: [:index, :show, :update, :destroy], path: 'members', as: :members

        resources :group_posts, path: 'posts', as: :posts do
          resources :group_post_comments, only: [:create, :destroy], path: 'comments', as: :comments
        end
      end
    end
  end

  # 管理者用ルーティング
  namespace :admin do
    root to: 'dashboard#top'
  
    # 管理者への申し送りなどの記載に使用するために設置
    resources :admin_notes, only: [:index, :create, :edit, :update, :destroy], path: 'notes', as: :notes do
      member do
        patch :reactivate         # 論理削除から復元
      end
    end

    # ユーザーへのニュースやお知らせ
    resources :informations, only: [:index, :create, :edit, :update, :destroy] do
      member do
        patch :reactivate         # 論理削除から復元
      end
    end

    # ユーザー管理
    resources :users, only: [:index, :show, :update] do
      member do
        patch :deactivate         # 凍結や強制退会等
        patch :reactivate         # 論理削除から復元
      end
    end

    # ユーザーの投稿管理
    resources :user_posts, only: [:index, :show, :destroy] do
      member do
        patch :reactivate         # 論理削除から復元
        patch :hide               # 非公開にする
        patch :publish            # 公開にする
      end
    end

    # ユーザーの投稿hへのコメント管理
    resources :user_post_comments, only: [:index, :show, :destroy] do
      member do
        patch :reactivate         # 論理削除から復元
        patch :hide               # 非公開にする
        patch :publish            # 公開にする
      end
    end

    # -----今後実装予定-----
    # グループ管理
    resources :groups, only: [:index, :show, :destroy] do
      member do
        patch :deactivate         # 凍結や強制退会等
        patch :reactivate         # 論理削除から復元
      end
    end

    # グループ内投稿の管理
    resources :group_posts, only: [:index, :show, :destroy], path: 'posts', as: :posts do
      resources :group_post_comments, only: [:destroy], path: 'comments', as: :comments
    end
  
    # DM機能(フレンド同士)
    resources :dm_rooms, only: [:index, :show, :destroy] do
      resources :messages, only: [:destroy]
    end

  end
end  