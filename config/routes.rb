Rails.application.routes.draw do


  resources :cover_images, only: [:show]

  # todo: wrap admin
  devise_for :users
  namespace :admin do
    resources :cover_images do
      member do
        get :reprocess
      end
    end
    require 'sidekiq/web'
    mount Sidekiq::Web => '/workers'
  end

  root to: "admin/cover_images#index"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
