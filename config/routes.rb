Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    post "users/upload", to: "users/registrations#upload", as: "upload_registration"
    post "users/disconnect" => 'users/registrations#disconnect', as: "disconnect_provider"
  end

  get 'welcome/index'
  root 'welcome#index'

  get 'index' => 'welcome#index'
  get 'sp' => 'sp#index'
  get 'confirm' => 'confirm#show'
  get 'mypage' => 'mypages#show'
  get 'terms' => 'terms#show'
  get 'privacy' => 'privacy#show'

  resources :communities, :only => [:new, :create, :show, :edit, :update, :destroy] do
    resources :boards, :only => [:new, :create, :show, :edit, :update, :destroy]
  end

  resources :t_cards, :only => [:edit, :update]

  post 'communities/:id/tasks/:t_card_id/toggle' => 'communities#toggle'
  get 'communities/:id/refresh_tasks' => 'communities#refresh_tasks'
  get 'communities/:id/invitable_users' => 'communities#invitable_users'
  post 'communities/:id/invite' => 'communities#invite'
  post 'communities/:id/accept' => 'communities#accept'
  post 'communities/:id/decline' => 'communities#decline'
  post 'communities/:id/leave' => 'communities#leave'
  post 'communities/:id/remove' => 'communities#remove'
  get 'communities/:id/members' => 'communities#members'
  
  post 'mypage/tasks/:id/toggle' => 'mypages#toggle'
  get 'mypage/refresh_tasks' => 'mypages#refresh_tasks'

  mount ActionCable.server => '/cable'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
