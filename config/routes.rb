Rails.application.routes.draw do
# 管理者用
# URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

#管理者側ルーディング
namespace :admin do
  root to: "homes#top"
  resources :posts, only: [:index, :show, :destroy, :edit, :update] do
    resources :post_comments, only: [:destroy]
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
  end
  get '/search', to: 'searches#search'
end

# 顧客用
# URL /users/sign_in ...
  devise_for :users,  skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

# 顧客側ルーディング
  scope module: :public do
    root to: "homes#top"
    get 'about' => 'homes#about'
    resources :posts, only: [:new, :create, :index, :show, :destroy, :edit, :update] do
      resources :post_comments, only: [:create, :destroy, :update, :edit]
      resource :favorites, only: [:create, :destroy]
    end
    resources :users, only: [:show, :edit, :update, :destroy, :index] do
      member do
        get :favorites
      end
    end
    get '/search', to: 'searches#search'
    get 'search_tag', to: 'posts#search_tag'
  end

# ゲストユーザー
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
end
