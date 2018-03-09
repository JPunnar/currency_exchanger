# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'exchange_reports#index'
    end

    unauthenticated do
      root 'devise/sessions#new'
    end
  end
  resources :exchange_reports
  get "/info", to: "exchange_reports#info"
end
