Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :rooms, only: [:index, :create, :destroy]
    end
  end
  
  scope :api do
    scope :v1 do
      devise_for :users,
                 path: '',
                 path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
                 defaults: { format: :json }
    end
  end
end
