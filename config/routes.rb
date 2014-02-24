WatchMe::Application.routes.draw do

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  resources :streams
  resources :messages
  
  devise_for :users
  
  get '/publish' => 'streams#info', as: 'publish'
  get '/pubauth' => 'publish#publish'
  get '/:id' => 'streams#show'
  
  root 'home#index'

end
