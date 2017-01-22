Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'sessions#index'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get "/auth/:provider/callback" => 'users#get_token'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/opportunities' => 'opportunities#index', as: 'opportunities'
  post '/opportunities' => 'opportunities#create'
  get '/opportunities/:id' => 'opportunities#show', as: 'opportunity'
  post '/opportunities/:id' => 'opportunities#find_email'
  get '/opportunities/:id/email' => 'opportunities#send_email'
  get '/companies/:id/opportunities' => 'opportunities#new', as: "company_opportunities"
  post '/companies/:id/opportunities' => 'opportunities#create', as: "company_add_opportunities"
  delete '/opportunities/:id' => 'opportunities#destroy'

  get '/companies' => 'companies#index', as: "companies"
  get '/companies/new' => 'companies#new', as: 'new_company'
  get '/companies/:id' => 'companies#show', as: 'company'
  post '/companies/new' => 'companies#new'
  post '/companies' => 'companies#create'
  get '/companies/autocomplete_company_name'

  get '/dashboard' => 'users#dashboard',  as: 'dashboard'
  get '/dashboard' => 'users#email'
  post '/dashboard' => 'users#email'
  get '/dashboard/new_event' => 'users#new_event', as: 'new_event'

end
