Superscription::Application.routes.draw do

  root :to => "static_pages#home"

  get :read, :to => "subscriptions#main"

  devise_for :users

  resources :users, :only => [] do
    resources :subscriptions, :only => [:index, :new]
    resources :categories, :only => [:new, :create, :show]
  end

  resources :subscriptions, :only => [:create, :edit, :update, :show, :destroy]


end
