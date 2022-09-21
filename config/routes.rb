Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :rooms, only: [:index, :create, :destroy]
      resources :reservations, only: [:index, :create, :destroy]
    end
  end
  
  scope :api do
    scope :v1 do
      devise_for :users,
                 path: '',
                 path_names: { sign_in: 'login', sign_out: 'logout', registration: 'register' },
                 defaults: { format: :json },
                 controllers: {
                  registrations: 'api/v1/users/registrations',
                  sessions: 'api/v1/users/sessions'
                 }
    end
  end
end
