Rails.application.routes.draw do
  namespace :v1 do
    resources :vagas, :controller => :jobs, only: [:create, :index] do
      resource :candidaturas, only: [] do
        get :ranking, to: 'applications#ranking'
      end
    end

    resources :pessoas, :controller => :users, only: [:create, :index]

    resources :candidaturas, :controller => :applications, only: [:create, :destroy]

    resources :locais, :controller => :locations, only: [:create, :destroy, :index]

  end
end
