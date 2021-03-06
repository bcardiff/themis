Rails.application.routes.draw do
  devise_for :users

  post 'ona/issued_class' => 'ona#issued_class'

  namespace :admin do
    get '/' => 'welcome#index', as: :index
    get 'teacher_cash_incomes' => 'welcome#teacher_cash_incomes'
    get 'teacher_courses' => 'welcome#teacher_courses'
    get 'horarios_wp' => 'welcome#horarios_wp'
    get 'balance' => 'welcome#balance'
    get 'missing_payments' => 'welcome#missing_payments'

    get 'ona_api/*path' => 'ona_submissions#api_forward'

    get 'pricing' => 'welcome#pricing', as: :pricing
    post 'pricing' => 'welcome#pricing_update'

    resources :ona_submissions, only: :index do
      collection do
        get :missing_forms
      end
      member do
        post :reprocess
        post :dismiss
        post :yank
        post :pull_from_ona
        get :ona_edit
      end
    end

    resources :users, only: [:index, :show, :update] do
      member do
        get :become
      end
    end
    resources :courses, only: [:index, :new, :create, :show, :update, :destroy] do
      collection do
        get :listing
      end
    end
    resources :students, only: [:index, :show, :edit, :update, :new, :create, :destroy] do
      member do
        post :cancel_debt
      end
      collection do
        get :stats
        get :stats_details
        get :missing_payment

        get :flow_stats
        get :flow_stats_drops_details
        get :course_stats
        get :drop_off_stats
        get :drop_off

        delete 'activity_log/:id' => 'students#remove_activity_log', as: :activity_log
        delete 'pack/:id' => 'students#remove_pack', as: :pack
        post 'pack/:id/advance' => 'students#advance_pack', as: :advance_pack
        post 'pack/:id/postpone' => 'students#postpone_pack', as: :postpone_pack
      end
    end

    resources :teachers, only: [:index, :show, :update] do
      member do
        get :owed_cash
        post :transfer_cash_income_money

        get :due_course_salary
        post :pay_pending_classes

        get :month_activity
      end
    end

    resources :course_logs, only: :show do
      resources :student_course_logs, only: [:create, :edit, :update, :destroy]

      get :autocomplete_student, :on => :collection
    end
  end

  namespace :teacher do
    get '/' => 'welcome#index', as: :index
    get '/how_to' => 'welcome#how_to', as: :how_to

    get '/owed_cash' => 'welcome#owed_cash', as: :owed_cash
    post '/accounting/venue_rent' => 'welcome#venue_rent', as: :venue_rent

    resources :course_logs, only: :show

    resources :ona_submissions, only: :index

    resources :students, only: [:index, :show]

  end

  namespace :place do
    get '/' => 'welcome#index', as: :index

    resources :ona_submissions, only: :index
  end

  namespace :room do
    get '/sign_in' => 'base#session_new', as: :login
    post '/sign_in' => 'base#session_create'

    get '/' => 'attendance#choose_place'
    get '/choose_course/:place_id' => 'attendance#choose_course', as: :choose_course
    post '/open/:date/:course_id' => 'attendance#open', as: :open
    get '/course_log/:id/teachers' => 'attendance#choose_teachers', as: :choose_teachers
    post '/course_log/:id/teachers' => 'attendance#choose_teachers_post'

    get '/course_log/:id/students' => 'attendance#students', as: :students

    get '/course_log/:id/students/search' => 'attendance#search_student'
    post '/course_log/:id/students' => 'attendance#add_student'
    delete '/course_log/:id/students' => 'attendance#remove_student'
    post '/course_log/:id/students_no_card' => 'attendance#add_students_no_card'
    delete '/course_log/:id/students_no_card' => 'attendance#remove_students_no_card'
  end

  scope "/cashier/:place_id", module: :cashier, as: :cashier do
    get '/dashboard' => 'dashboard#index'
    get '/calendar' => 'dashboard#calendar'
    get '/status' => 'dashboard#status'
    get '/owed_cash' => 'dashboard#owed_cash'

    get '/receipt' => 'receipt#index'
    post '/receipt' => 'receipt#validate'

    post '/open_course' => 'dashboard#open_course'

    resources :students, only: [:index, :show, :create, :edit, :update] do
      member do
        post 'single_class_payment/:student_course_log_id' => 'students#single_class_payment'
        post 'pack_payment' => 'students#pack_payment'
        post 'track_in_course_log' => 'students#track_in_course_log'
        delete 'pack/:student_pack_id' => 'students#remove_pack', as: :delete_pack
      end
      collection do
        get 'course'
      end
    end
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
