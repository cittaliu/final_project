Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'sessions#index'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/dashboard' => 'users#dashboard',  as: 'dashboard'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/opportunities' => 'opportunities#index', as: 'opportunities'

  get '/companies/:id' => 'companies#show', as: 'company'


end
