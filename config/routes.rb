Rails.application.routes.draw do

  root 'welcome#index'
  get '/dashboard', to: 'dashboard#index'
  get '/login', to: 'sessions#create'

  namespace :user do
    resources :subreddits, only: [:index, :show]
  end
end
