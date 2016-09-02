Rails.application.routes.draw do

  resource :cover_images, only: [:show]

  namespace :admin do
    resources :cover_images
  end

  root to: "admin/cover_images#index"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
