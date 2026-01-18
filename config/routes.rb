Rails.application.routes.draw do
  devise_for :users
  
  root to: "teams#index"
  
  resources :users, only: [:show]
  resources :teams, only: [:index, :show] do
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]
    end
  end

  get 'about', to: 'homes#about', as: 'about'
  get '/users/mypage', to: 'users#mypage', as: 'users_mypage'
end