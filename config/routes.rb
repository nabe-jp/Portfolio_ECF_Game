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
      get :show, as: :show, on: :member

      resources :user_posts, path: 'posts', as: :posts, module: :users do
        resources :user_post_comments, only: [:create, :destroy], path: 'comments', 
          as: :comments
      end
    end
    
    # 自分が所属しているグループ一覧を表示する機能(責務を混ぜず、IDも必要ないので独立ルート)
    get 'my_groups', to: 'groups#my_groups'

    # スラッグを使用
    resources :groups, param: :slug do
      get :confirm_destroy, on: :member       # 削除確認画面

      # グループメンバーの専用ページ
      # dashboardはこのままでは複数形のコントローラーが使用されるので単数形を使用するように変更
      scope module: :groups do

        # 管理者が他メンバーを操作する用
        resources :group_memberships, only: [:index], path: 'memberships' , as: :memberships do
          member do
            post :approve                     # 申請承認
            post :reject                      # 申請却下
          end
        end

        resource :group_membership, only: [], path: 'membership', as: :membership do
          post :join                          # 参加する
          delete :leave                       # 退出する
          delete :cancel                      # 参加申請をキャンセルする
        end

        resource :group_dashboard, only: [:show], path: 'dashboard', as: :dashboard, 
          controller: 'group_dashboard'

        resources :group_events, path: 'events', as: :events
        resources :group_notices, path: 'notices', as: :notices
        resources :group_members, only: [:index, :show, :destroy], path: 'members', as: :members  do
          member do
            get :edit_note
            patch :update_role
            patch :update_note
          end
        end

        resources :group_posts, path: 'posts', as: :posts do
          resources :group_post_comments, only: [:create, :destroy], path: 'comments', as: :comments
        end
      end
    end
  end

  # 論理削除から復元
  concern :admin_reactivatable do
    patch :reactivate, on: :member
  end

  # 公開制御
  concern :admin_publishable do
    patch :hide, on: :member               # 非公開にする
    patch :publish, on: :member            # 公開にする
  end

  # 管理者用ルーティング
  namespace :admin do
    root to: 'dashboard#top'

    # 検索機能
    resources :searches, only: [:index]
  
    # 管理者への申し送りなどの記載に使用するために設置
    resources :admin_notes, only: [:index, :create, :edit, :update, :destroy], 
      path: 'notes', as: :notes, concerns: :admin_reactivatable

    # ユーザーへのニュースやお知らせ
    resources :informations, only: [:index, :create, :edit, :update, :destroy], 
      concerns: :admin_reactivatable

    # ユーザー管理
    resources :users, only: [:index, :show, :destroy], concerns: :admin_reactivatable do 
      patch :activate, on: :member        # アクティブにする
    end

    # ユーザーの投稿管理
    resources :user_posts, only: [:index, :show, :destroy], 
      concerns: [:admin_reactivatable, :admin_publishable]

    # ユーザーの投稿へのコメント管理
    resources :user_post_comments, only: [:index, :show, :destroy], 
      concerns: [:admin_reactivatable, :admin_publishable]

    # グループ管理
    resources :groups, only: [:index, :show, :destroy], 
      concerns: [:admin_reactivatable, :admin_publishable] do

      scope module: :groups do
        resources :group_members, only: [:index, :show, :destroy], 
          path: 'members', as: :members, concerns: [:admin_reactivatable, :admin_publishable]
        
        resources :group_events, only: [:index, :show, :destroy], 
          path: 'events', as: :events, concerns: [:admin_reactivatable, :admin_publishable]

        resources :group_notices, only: [:index, :show, :destroy], 
          path: 'notices', as: :notices, concerns: [:admin_reactivatable, :admin_publishable]

        resources :group_posts, only: [:index, :show, :destroy], 
          path: 'posts', as: :posts, concerns: [:admin_reactivatable, :admin_publishable]

       resources :group_post_comments, only: [:index, :show, :destroy], 
          path: 'post_comments', as: :post_comments, concerns: [:admin_reactivatable, :admin_publishable]
      end
    end

    # DM機能(フレンド同士)
    resources :dm_rooms, only: [:index, :show, :destroy] do
      resources :messages, only: [:destroy]
    end

  end
end  