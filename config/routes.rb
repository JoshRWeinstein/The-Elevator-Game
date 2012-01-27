Elevatorux::Application.routes.draw do
  root :to => 'rides#show'
  resources :ride
  

end
