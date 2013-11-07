Superscription::Application.routes.draw do

  root :to => "static_pages#home"

  get :read, :to => "subscriptions#main"

  devise_for :users

  resources :users, :only => [] do
    resources :subscriptions, :only => [:index, :new]
    resources :categories, :only => [:new, :create, :show]
  end

  resources :subscriptions, :only => [:create, :show]

  namespace "api", :defaults => { :format => :json } do
    resources :user_subscriptions, :only => [:destroy]
  end

end
