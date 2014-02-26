WatchMe::Application.routes.draw do

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  resources :streams
  resources :messages
  
  devise_for :users
  
  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end
  
  get '/publish' => 'streams#info', as: 'publish'
  get '/publish/fmle.xml' => 'streams#fmle', as: 'fmle'
  get '/pubauth' => 'publish#publish'
  get '/:id' => 'streams#show'
  get '/streams/:id/source.smil' => 'streams#smil', as: 'smil'
  
  root 'home#index'

end
