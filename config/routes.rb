Superscription::Application.routes.draw do

  root :to => "static_pages#home"

  get :read, :to => "subscriptions#main"

  devise_for :users
  post :guest, :to => "guest_users#create"

  resources :users, :only => [] do
    resources :subscriptions, :only => [:index, :new]
    resources :categories, :only => [:new, :create]
  end

  resources :subscriptions, :only => [:create, :show]

  get :categories, :to => "categories#manage"

  namespace "api", :defaults => { :format => :json } do
    resources :user_subscriptions, :only => [:destroy]
    resources :readings, :only => [:create]
  end

end
