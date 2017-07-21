Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    post "users/upload", to: "users/registrations#upload", as: "upload_registration"
  end

  get 'welcome/index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get 'index' => 'welcome#index'
  get 'confirm' => 'confirm#show'
  get 'mypage' => 'mypages#show'

  resources :communities, :only => [:new, :create, :show, :edit, :update, :destroy] do
    resources :boards, :only => [:new, :create, :show, :edit, :update, :destroy]
  end

  post 'communities/:id/tasks/:t_card_id/toggle' => 'communities#toggle'
  get 'communities/:id/refresh_tasks' => 'communities#refresh_tasks'
  get 'communities/:id/invitable_users' => 'communities#invitable_users'
  post 'communities/:id/invite' => 'communities#invite'
  post 'communities/:id/accept' => 'communities#accept'
  post 'communities/:id/decline' => 'communities#decline'

  post 'mypage/tasks/:id/toggle' => 'mypages#toggle'
  get 'mypage/refresh_tasks' => 'mypages#refresh_tasks'
  post 'mypage/create_community' => 'mypages#create_community'

  mount ActionCable.server => '/cable'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
