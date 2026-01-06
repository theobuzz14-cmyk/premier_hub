Rails.application.routes.draw do
  get 'homes/about'
  devise_for :users
  
  root to: "teams#index"
  
  resources :teams, only: [:index, :show] do
    resources :posts, except: [:index]
  end

  get 'about', to: 'homes#about', as: 'about'
end