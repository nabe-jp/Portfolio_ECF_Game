Rails.application.routes.draw do
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

  # 会員用ルーティング
  scope module: :public do
    root to: "homes#top"
    get 'about', to: 'homes#about'

    # マイページは個人情報を取り扱い、自分の設定の変更はほかのユーザーはしないのでidを持たないように設計
    # パスプレフィックスにするため、カスタムをdoで囲まない
    # deviseとurlがかさなるので'users/profile'に変更、edit_user_pathとなりeditだけ外れるためカスタム
    # resource :user, only: [:update, :destroy], path: 'user/profile', as: 'user' do
    #   get 'edit', to: 'user#edit', as: ''
    # end
 
    #  resource :user, only: [show] do
    #   resources :posts, only: [:index, :show]
    # end

    # # updateやdestroyのControllerがusersになるためカスタムで作成(応急処置)
    # get 'user/profile/edit', to: 'user#edit', as: 'user'
    # patch 'user/profile/edit', to: 'user#update', as: ''
    # delete 'user/profile/edit', to: 'user#destroy', as: ''

    # get 'user/show', to: 'user#show', as: 'user_show'
    # get 'user/mypage', to: 'user#mypage', as: 'user_mypage'
    # get 'user/settings', to: 'user#settings', as: 'user_settings'
    # get 'user/check', to: 'user#check', as: 'user_check'
    # patch 'user/withdraw', to: 'user#withdraw', as: 'user_withdraw'

    # # 自分(ログインユーザー)の投稿操作(更新後に自身の投稿も閲覧するのでindex、showも含めている)
    # resource :user, only: [] do
    #   get 'post/index', to: 'posts#index', as: 'post_index'
    #   get 'post/:id/show', to: 'posts#show', as: 'post_show'

    #   resources :posts, only: [:new, :create, :edit, :update, :destroy]
    # end

    # # ほかのユーザーの投稿を見るため
    # resources :users, only: [:show] do
    #   resources :posts, only: [:index, :show]
    # end

    # # 自身も含めたすべての投稿を見るため
    # resources :posts, only: [:index]


    # 自分自身の設定(単数リソースを使用、usersリソースとの衝突を避けるためcontrollerオプションで設定)
    # :idは付きませんがユーザーに対する操作であることを明示的にするためにmemberを使用しています
    resource :user, only: [:show, :edit, :update], controller: 'user' do
      member do
        get 'mypage'
        get 'settings'
        get 'check'
        patch 'withdraw'
      end
    end
    
    # showはresource_userにもあるのでuser_post_pathに配置される、そこでも衝突が起こるのでpathを設定しています
    # リソースフルにするために投稿はresource_userにネストせずresources_usersにネストしました
    resources :users, only: [] do
      member do
        get 'show', as: 'show'
      end
      resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    end

    # ユーザーの全投稿用(indexだけのためresourcesは使用せずカスタム)
    get 'users/posts', to: 'posts#index', as: 'user_all_posts'


    # 他の会員用ルーティング
  end

  # 管理者用ルーティング
  namespace :admin do
    root to: "dashboard#top"

    # リンクをテストするためのページ
    get 'button/test', to: 'button#test', as: 'button_test'
    # 他の管理用ルーティング
  end
end