Rails.application.routes.draw do
  devise_for :users
  root to: redirect('/projects')

  resources :projects do
    resources :tasks, except: [:index, :show]
  end

  resources :tasks, only: [] do
    collection do
      get :overdue
      get :trash
    end
  end

  get 'search', to: 'search#index'
end
