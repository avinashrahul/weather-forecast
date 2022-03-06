Rails.application.routes.draw do
  root 'weather#zipcode'
  get '/zipcode', to: 'weather#zipcode'
end
