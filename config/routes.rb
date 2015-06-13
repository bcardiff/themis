Rails.application.routes.draw do
  devise_for :users

  post 'ona/issued_class' => 'ona#issued_class'

  namespace :admin do
    get '/' => 'welcome#index', as: :index
    get 'student_payments' => 'welcome#student_payments'
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
    resources :students, only: [:index, :show]

    resources :teachers, only: [:index, :show] do
      member do
        get :owed_student_payments
        post :transfer_student_payments_money

        get :due_course_salary
        post :pay_pending_classes
      end
    end

    resources :course_logs, only: :show
  end

  namespace :teacher do
    get '/' => 'welcome#index', as: :index
    get '/how_to' => 'welcome#how_to', as: :how_to

    resources :course_logs, only: :show
  end

  root 'welcome#index'

  post 'ona' => 'ona#json_post'
  # post 'ona/teach' => 'ona#teach'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  mount Listings::Engine => "/listings"

  get 'forbidden' => 'welcome#forbidden'

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
