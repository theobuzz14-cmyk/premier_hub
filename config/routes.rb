Rails.application.routes.draw do
  devise_for :users
  
  root to: "teams#index"
  
  resources :users, only: [:show]
  resources :teams, only: [:index, :show] do
    resources :posts, except: [:index]
  end

  get 'about', to: 'homes#about', as: 'about'
end