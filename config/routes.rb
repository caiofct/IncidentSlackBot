Rails.application.routes.draw do
  resources :incidents
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post "/slack/commands", to: "slack#commands"
  post "/slack/interactions", to: "slack#interactions"

  resources :incidents, only: [ :index ]

  root "incidents#index"
end
