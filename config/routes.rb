Superscription::Application.routes.draw do

  root :to => "static_pages#home"

  get :read, :to => "subscriptions#main"

  devise_for :users

  resources :users, :only => [] do
    resources :subscriptions, :only => [:index, :new]
  end

  resources :subscriptions, :only => [:create, :edit, :update, :show, :destroy]


end
