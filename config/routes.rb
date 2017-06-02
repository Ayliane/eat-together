Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :restaurants, only: [:index, :show]
  get 'foodora', to: "restaurants#foodora"
  get 'deliveroo', to: "restaurants#deliveroo"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :restaurants, only: [ :index, :show ], param: :address
    end
  end
end
