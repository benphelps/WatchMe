WatchMe::Application.routes.draw do

  resources :streams
  resources :messages
  
  devise_for :users
  
  get '/publish' => 'publish#publish'
  
  root 'home#index'

end
