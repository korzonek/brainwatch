Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :questions do
    resources :answers, shallow: true
  end
end
