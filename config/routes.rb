Rails.application.routes.draw do
  devise_for :users
  root to: "homes#top"
  get 'about' => 'homes#about'
  resources :posts, only: [:new, :create, :index, :show, :destroy, :edit, :update]
  resources :users, only: [:show, :edit, :update, :destroy]
  get '/search', to: 'searches#search'
end
