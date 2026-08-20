Rails.application.routes.draw do
  resources :clientes
  resources :vehiculos
  resources :especialidades
  resources :mecanicos
  resources :bahias
  resources :servicios
  resources :proveedores
  resources :repuestos

  resources :ordenes_trabajo, only: [ :index, :new, :create, :show ] do
    member do
      post :transicionar
      post :cancelar
      post :finalizar
    end
    resources :ordenes_mecanicos, only: [ :create, :destroy ]
    resource :diagnostico, only: [ :new, :create, :show, :edit, :update ] do
      member do
        post :validar
      end
    end
    resource :presupuesto, only: [ :new, :create, :show, :edit, :update ] do
      member do
        post :aprobar
        post :rechazar
      end
    end
    resources :detalles_ordenes_servicios, only: [ :create, :destroy ]
    resources :detalles_ordenes_repuestos, only: [ :create, :destroy ]
  end

  resources :facturas, only: [ :index, :new, :create, :show ] do
    member do
      post :pagar
    end
  end

  resource :session
  resources :passwords, param: :token

  root "home#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
