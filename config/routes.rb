Rails.application.routes.draw do
  devise_for :users
	root 'exchange_reports#index'
  resources :exchange_reports
end
