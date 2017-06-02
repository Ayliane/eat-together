Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :restaurants, only: [:index, :show]
  get 'foodora', to: "restaurants#foodora"
  get 'deliveroo', to: "restaurants#deliveroo"

  get 'foodora_show', to: "restaurants#foodora_show"
  get 'deliveroo_show', to: "restaurants#deliveroo_show"
end


