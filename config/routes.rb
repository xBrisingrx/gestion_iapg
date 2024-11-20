Rails.application.routes.draw do
  resources :instructors, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :units, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :course_types, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :rooms, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :headquarters, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :sectionals, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :companies, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :iva_conditions, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :sectors, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :company_categories, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  root "home#index"
  resources :people, expect: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  draw(:authentication)
  draw(:errors)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "main#index"
end
