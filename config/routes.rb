Rails.application.routes.draw do

  devise_for :users

  resources :pins do
  	collection do
  		get 'search'
  	end
  	member do
  		put "like",    to: "pins#upvote"
  	end
  end

  root "pins#index"
end
