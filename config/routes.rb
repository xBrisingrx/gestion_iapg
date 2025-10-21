Rails.application.routes.draw do
  resources :course_hours_turns
  get "certificates/index"
  get "certificates/courses_by_type", to: "certificates#courses_by_type"
  get "certificates/get_people_in_course", to: "certificates#get_people_in_course"
  get "certificates/generate_certificate", to: "certificates#generate_certificate"
  namespace :api do
    post "elearning", to: "elearning#index"
    get "get_course_module", to: "elearning#get_course_module"
    post "get_resultados", to: "elearning#get_resultados"
    post "encuesta", to: "elearning#encuesta"
    # credenciales
    post "credential_login", to: "credential#login"
    get "credential_person_data", to: "credential#credential_person_data"
    get "provincias", to: "credential#provincias"
    get "localidades", to: "credential#localidades"
    get "empresas", to: "credential#empresas"
    get "savedatos", to: "credential#savedatos"
  end
  resources :module_questions
  resources :module_videos
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
    resources :in_company, only: [ :new, :create ]
    resources :theoric, only: [ :new, :create ]
    resources :psicometric, only: [ :new, :create ]
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
    get "get_teoricos_by_category", on: :collection
    get "get_teoricos_in_company", on: :collection
    get "get_cursos_practicos", on: :collection
    get "get_psicometricos", on: :collection
    get "register_scoring_modal", on: :member
    get "add_instructor", to: "course_units#modal_add_instructor"
    post "add_instructor", to: "course_units#add_instructor"
    post "change_turn", to: "courses#change_turn"
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
