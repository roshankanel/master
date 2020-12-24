Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users
  resources :users
  resources :items
  resources :stores
  resources :quotes
  # Role and Permission related
  resources :permissions
  resources :roles do
    get  'update_permissions'
    post 'save_permissions'
    patch 'save_permissions'
  end

  get '/users/:id/roles', controller: 'users', action: 'show_roles', as: 'show_roles'
  match '/users/:id/save_roles', to:'users#save_roles', via: [:patch, :post], as: 'user_roles_save'
  match '/users/:id/update_approve', to:'users#update_approve', via: [:patch, :post], as: 'user_approve'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
