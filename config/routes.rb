Superscription::Application.routes.draw do

  devise_for :users
  
  resources :users, :only => [] do
    resources :subscriptions, :only => [:index, :new]
  end

  resources :subscriptions, :only => [:create, :edit, :update, :show, :destroy]

end
