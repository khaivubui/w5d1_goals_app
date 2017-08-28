Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:new, :create] do
    resources :goals, only: :index
  end

  resource :session, only: [:new, :create, :destroy]

  resources :goals

  root to: 'sessions#new'
end
