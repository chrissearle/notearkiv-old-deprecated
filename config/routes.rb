ActionController::Routing::Routes.draw do |map|
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.onelogin 'login_once/:code', :controller => 'user_sessions', :action => 'new_once'
  
  map.forgot 'forgotten_password', :controller => 'user_sessions', :action => 'forgotten'
  map.reset 'reset_password', :controller => 'user_sessions', :action => 'reset'

  map.resources :user_sessions

  map.resources :users

  map.root :controller => "notes"

  map.resources :stats
  map.resources :periods
  map.resources :genres
  map.resources :composers
  map.resources :languages
  map.resources :notes, :collection => { :voice => :get }
  map.resources :evensongs
  map.resources :account
end
