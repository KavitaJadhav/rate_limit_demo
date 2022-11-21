Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'sign_in', to: 'authentication#authenticate'
  post 'contact_us', to: 'support_ticket#create'
end
