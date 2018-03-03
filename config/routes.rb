Rails.application.routes.draw do
  devise_for :users
	root 'exchange_reports#index'
  resources :exchange_reports
  get '/info', to: 'exchange_reports#info'
end
