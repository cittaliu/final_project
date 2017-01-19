Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'sessions#index'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/dashboard' => 'users#dashboard',  as: 'dashboard'
  get '/authorization' => 'users#authorization'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/opportunities' => 'opportunities#index', as: 'opportunities'
  get '/opportunities/new' => 'opportunities#new', as: 'new_opportunity'
  post '/opportunities' => 'opportunities#create'
  get '/opportunities/:id' => 'opportunities#show', as: 'opportunity'
  post '/opportunities/:id' => 'opportunities#find_email'

  get '/companies/:id' => 'companies#show', as: 'company'

  get "/auth/:provider/callback" => 'users#get_token'
  get '/dashboard' => 'users#email'
  post '/dashboard' => 'users#email'

end
