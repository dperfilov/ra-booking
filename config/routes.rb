Rails.application.routes.draw do
  get "bookings/index"
  # get "bookings/get_template_info"
  # post "bookings/get_template_info"
  
  get "bookings/stage1_get_rests"
  post "bookings/stage1_get_rests"

  get "bookings/get_time_slots"
  post "bookings/get_time_slots"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "bookings#stage1"
end
