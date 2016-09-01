Rails.application.routes.draw do

  resource :document, only: [:get]

  namespace :admin do
    resources :images
  end

  root to: "admin/images#index"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
