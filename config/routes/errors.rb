match "/404", via: :all, to: "errors#not_found"
match "/500", via: :all, to: "errors#internal_server_error"
get "unauthorized", to: "errors#unauthorized"
