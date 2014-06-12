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
  
  get '/:id' => 'streams#show'
  get '/:id/popout' => 'streams#popout', as: 'stream_popout'
  get '/streams/:id/popout' => 'streams#popout'
  
  get '/vod/:name' => 'vods#index', as: 'vod'
  get '/vod/:name/:id' => 'vods#show', as: 'vod_show'
  
  root 'home#index'

end
