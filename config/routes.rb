Elevatorux::Application.routes.draw do
  root :to => 'rides#show'
  resources :rides
  match "rides/update" => 'rides#update'
  
end
