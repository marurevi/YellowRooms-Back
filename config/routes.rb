Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      
    end
  end
  
  scope :api do
    scope :v1 do
      devise_for :users,
                 path: '',
                 path_names: { sign_in: 'login', sign_out: 'logout', registration: 'register' },
                 defaults: { format: :json },
                 controllers: {
                  registrations: 'api/v1/users/registrations'
                 }
    end
  end
end
