Rails.application.routes.draw do
  root 'weather#new'
  get '/zipcode', to: 'weather#zipcode'
end
