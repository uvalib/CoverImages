Rails.application.routes.draw do

  resources :cover_images, only: [:show], id: /.*?/, format: /[^.]+/

  devise_scope :user do
    get "/users/sign_up", to: redirect('/404')
    post "/users", to: redirect('/404')
    get "/login" => "users/sessions#new"

    # used only to prevent errors in development
    # netbadge will catch this path in prod
    get "/logout", to: "users/sessions#new"
  end
  devise_for :users, controllers: { sessions: 'users/sessions' }

  authenticate :user do
    namespace :admin do
      resources :cover_images do
        member do
          get :reprocess
        end
      end
      require 'sidekiq/web'
      mount Sidekiq::Web => '/workers'
    end
  end

  root to: "admin/cover_images#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
