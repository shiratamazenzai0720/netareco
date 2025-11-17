Rails.application.routes.draw do
  resources :posts
  devise_for :users
  get 'about' => 'homes#about'
  root to: "homes#top"
  get 'posts/:id' => 'posts#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
