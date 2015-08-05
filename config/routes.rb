Rails.application.routes.draw do

  devise_for :users
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  
  # View that serves the one-page app
  root 'main#index'

  # AngularJS view of owned courses
  get 'courses' => 'main#courses', as: :courses_view
  
  # AngularJS view of sections in a course 
  get 'calendar' => 'main#calendar', as: :calendar_view

  # AngularJS view of GSIs in a course 
  get 'gsi' => 'main#gsi', as: :gsi_view


  # AngularJS templates for the calendar directive
  get 'calendar_template.html' => 'calendar#calendar_template'
  get 'event_template.html' => 'calendar#event_template'
  get 'preference_template.html' => 'calendar#preference_template'

  scope "api" do
    resources :appointments,
              only: [:show, :index], defaults: { format: :json }
    resources :users, except: [:new, :edit], defaults: { format: :json }
    resources :courses, except: [:new, :edit], defaults: { format: :json } do
      resources :sections, except: [:new, :edit], defaults: { format: :json }
      resources :employments,
                except: [:new, :edit], defaults: { format: :json }
      resources :preferences,
                except: [:new, :edit], defaults: { format: :json } do
                  collection do
                    get :get
                    put :set
                  end
                end
    end
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
