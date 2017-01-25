Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'sessions#index'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get "/auth/:provider/callback" => 'users#get_token'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get 'users/:id/opportunities' => 'opportunities#index', as: 'opportunities'
  post 'users/:id/opportunities' => 'opportunities#create'
  get '/companies/:company_id/opportunities/:id' => 'opportunities#show', as: 'opportunity'
  post '/opportunities/:id' => 'opportunities#find_email'
  get '/opportunities/:id/email' => 'opportunities#send_email', as: "send_email"
  get '/companies/:id/opportunities' => 'opportunities#new', as: "company_opportunities"
  post '/companies/:id/opportunities' => 'opportunities#create', as: "company_add_opportunities"
  delete '/companies/:company_id/opportunities/:id' => 'opportunities#destroy'
  get '/companies/:company_id/opportunities/:id/new_email' => 'opportunities#email_editor', as: "email_editor"
  post '/companies/:company_id/opportunities/:id/new_email' => 'opportunities#send_email'

  get '/companies' => 'companies#index', as: "companies"
  get '/companies/autocomplete_company_name'
  get '/companies/new' => 'companies#new'
  get '/companies/:id' => 'companies#show', as: 'company'
  post '/companies/new' => 'companies#new'
  post '/companies' => 'companies#create', as: 'new_company'

  get '/dashboard' => 'users#dashboard', as: 'dashboard'
  get '/dashboard' => 'users#email'
  post '/dashboard' => 'users#email'
  get '/dashboard/new_event' => 'users#new_event', as: 'new_event'

  get '/users/:id/contacts' => 'contacts#index', as: 'contacts'
  get '/contacts/autocomplete_contact_name'
  get '/users/:id/contacts/:contact_id' => 'contacts#show', as: 'contact'
  post '/users/:id/contacts/:contact_id/events' => 'usercontacts#create', as: 'user_add_tasks'

  get '/companies/:id/contacts' => 'usercontacts#new', as: "company_contacts"
  post '/companies/:company_id/opportunities/:id' => 'usercontacts#create', as: "company_add_contacts"
  patch '/companies/:company_id/opportunities/:id/contacts/:contact_id' => 'opportunities#create'

  get '/tasks/new' => 'tasks#new', as: 'new_task'
  post '/tasks' => 'tasks#create'
  get '/usercontacts/:id' =>'usercontacts#show', as: 'usercontact'

end
