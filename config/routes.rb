WatchMe::Application.routes.draw do

  resources :streams
  resources :messages
  
  devise_for :users
  
  get '/publish' => 'publish#publish'
  get '/:id' => 'streams#show'
  
  root 'home#index'

end
