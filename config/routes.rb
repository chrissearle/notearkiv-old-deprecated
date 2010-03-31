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

  map.notesupload 'upload/notes', :controller => 'notes_upload', :action => 'upload'
  map.notesimport 'upload/notes/import', :controller => 'notes_upload', :action => 'import'
  map.evensongsupload 'upload/evensongs', :controller => 'evensongs_upload', :action => 'upload'
  map.evensongsimport 'upload/evensongs/import', :controller => 'evensongs_upload', :action => 'import'
end
