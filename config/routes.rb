Rails.application.routes.draw do
  resources :elearning_exams
  resources :exams, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
    resources :exam_questions, except: [ :destroy, :update, :edit ] do
      get "modal_disable", on: :member
      put "disable", on: :member
    end
    resources :exam_modules, except: [ :destroy, :update, :edit ] do
      get "modal_disable", on: :member
      put "disable", on: :member
    end
  end
  resources :videos, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :questions, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
    resources :answers do
      get "cancel_edit", on: :member
    end
  end
  namespace :courses do
    resources :registration
  end

  resources :courses, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
    get "turns_by_unit", on: :member
    get "turns", on: :member
    get "search", on: :collection
    get "register_attendance", on: :member
    get "scoring", on: :collection
    get "by_course_type", on: :collection
    get "by_course_category_and_fleet", on: :collection
    get "get_cursos_practicos", on: :collection
    get "get_psicometricos", on: :collection
    get "register_scoring_modal", on: :member
    resources :course_people, only: [ :index, :new, :create, :update ] do
      get "by_course", on: :collection
    end
    resources :course_units, only: [ :new, :create ] do
      get "people_registered", to: "course_units#people_registered"
    end
    resources :turns, only: [ :index, :edit, :update ]
  end
  resources :instructors, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
    get "is_available", to: "instructors#is_available"
  end
  resources :units, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :course_types, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
    get "get_yearly_and_general_number", on: :member
    resources :course_type_units do
      get "add_units_to_form", on: :collection
    end
  end
  resources :rooms, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :headquarters, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :sectionals, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :companies, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
    resources :company_managers, except: [ :destroy ] do
      get "get_to_select", on: :collection
    end
  end
  resources :iva_conditions, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :sectors, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :company_categories, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end
  resources :people, except: [ :destroy ] do
    get "modal_disable", on: :member
    put "disable", on: :member
  end

  get "calendar/month", to: "calendar#month"
  root "courses#index"
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
