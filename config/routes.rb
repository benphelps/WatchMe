WatchMe::Application.routes.draw do

  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  resources :streams
  resources :messages
  
  devise_for :users
  
  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end
  
  post '/notify' => 'notify#handle'
  get '/notify' => 'notify#handle'
  get '/publish' => 'streams#info', as: 'publish'
  get '/publish/fmle.xml' => 'streams#fmle', as: 'fmle'
  get '/pubauth' => 'publish#publish'
  get '/:id' => 'streams#show'
  get '/dash/:id' => 'streams#dash'
  get '/hls/:id' => 'streams#hls'
  get '/streams/:id/source.smil' => 'streams#smil', as: 'smil'
  
  root 'home#index'

end
