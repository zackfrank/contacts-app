Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/first_contact" => "contacts#first_contact"
    get "/all_contacts" => "contacts#all_contacts"
  end

  namespace :v2 do
    get "/contacts" => "contacts#index"
    post "/contacts" => "contacts#create"
    get "/contacts/:id" => "contacts#show"
    patch "/contacts/:id" => "contacts#update"
    delete "/contacts/:id" => "contacts#destroy"

    get "/users" => "users#index"
    post "/users" => "users#create"
    get "/users/:id" => "users#show"
  end
end
