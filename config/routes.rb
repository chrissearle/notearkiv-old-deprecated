# coding: UTF-8

Notearkiv::Application.routes.draw do
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'login' => 'user_sessions#new', :as => :login
  match 'login_once/:code' => 'user_sessions#new_once', :as => :onelogin

  match 'forgotten_password' => 'user_sessions#forgotten', :as => :forgot
  match 'reset_password' => 'user_sessions#reset', :as => :reset

  match 'download/:prefix/:type/:file.:format' => 'archive#download', :as => :download

  resources :user_sessions
  resources :users
  resources :stats
  resources :periods
  resources :genres
  resources :composers
  resources :languages
  resources :notes
  resources :evensongs
  resources :account

  match 'db_auth' => 'session_caches#authorize', :as => :authorize

  match 'upload/notes' => 'notes_upload#upload', :as => :notesupload
  match 'upload/notes/import' => 'notes_upload#import', :as => :notesimport

  match 'upload/evensongs' => 'evensongs_upload#upload', :as => :evensongsupload
  match 'upload/evensongs/import' => 'evensongs_upload#import', :as => :evensongsimport


  root :to => "notes#index"
end
