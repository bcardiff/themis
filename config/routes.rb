Rails.application.routes.draw do
  devise_for :users

  post 'ona/issued_class' => 'ona#issued_class'

  namespace :admin do
    get '/' => 'welcome#index', as: :index
    get 'teacher_cash_incomes' => 'welcome#teacher_cash_incomes'
    get 'teacher_courses' => 'welcome#teacher_courses'

    resources :ona_submissions, only: :index do
      member do
        post :reprocess
        post :dismiss
        post :pull_from_ona
        get :ona_edit
      end
    end

    resources :users, only: [:index, :show, :update]
    resources :courses, only: [:index]
    resources :students, only: [:index, :show, :edit, :update, :new, :create]

    resources :teachers, only: [:index, :show] do
      member do
        get :owed_cash
        post :transfer_cash_income_money

        get :due_course_salary
        post :pay_pending_classes
      end
    end

    resources :course_logs, only: :show
  end

  namespace :teacher do
    get '/' => 'welcome#index', as: :index
    get '/how_to' => 'welcome#how_to', as: :how_to

    get '/owed_cash' => 'welcome#owed_cash', as: :owed_cash

    resources :course_logs, only: :show

    resources :ona_submissions, only: :index

    resources :students, only: [:index, :show]

  end

  namespace :place do
    get '/' => 'welcome#index', as: :index

    resources :ona_submissions, only: :index
  end

  root 'welcome#index'

  post 'ona' => 'ona#json_post'
  # post 'ona/teach' => 'ona#teach'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  mount Listings::Engine => "/listings"

  get 'forbidden' => 'welcome#forbidden'
end
