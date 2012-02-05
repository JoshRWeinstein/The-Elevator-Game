Elevatorgame::Application.routes.draw do
  root :to => 'rides#show'
  resources :rides
  match "rides/update" => 'rides#update'
  match "leaders" => 'rides#leaders'
  match "rides/nameentry" => 'rides#nameentry'
  match "results" => "rides#staticresults"
end
