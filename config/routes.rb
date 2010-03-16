ActionController::Routing::Routes.draw do |map|
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
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
end
