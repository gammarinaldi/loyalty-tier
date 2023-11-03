Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :completed_orders, only: [:create, :index, :show]
      resources :customers, only: [:index, :show]
    end
  end
end
