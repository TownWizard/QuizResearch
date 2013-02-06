ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  map.resources :widgets, :member => {:get_api_widget => :get, :get_survey => :get}
#  map.resources :surveys
  # get first or specific page
 # set up apartial registration
  map.connect 'surveys/registration/:id', :controller => 'surveys', :action => 'registration', :conditions => { :method => :get }
  map.connect 'surveys/:id/register/', :controller => 'surveys', :action => 'register', :conditions => { :method => :post }

  # survey_instance (start)
  map.connect 'surveys/:id/start/', :controller => 'surveys', :action => 'start', :conditions => { :method => :post }

  # get first or specific page
  map.connect 'surveys/:id', :controller => 'surveys', :action => 'show', :conditions => { :method => :get }
  map.connect 'surveys/:id/:position', :controller => 'surveys', :action => 'show', :conditions => { :method => :get }

  map.connect 'surveys/:id', :controller => 'surveys', :action => 'new', :conditions => { :method => :post }
  map.connect 'surveys/:id/:position', :controller => 'surveys', :action => 'submit_answers', :conditions => { :method => :post }
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  map.resources :quizzes, :member => {:result => :get}

  map.connect 'quizzes/:id/start', :controller => 'quizzes', :action => 'start'#, :conditions => { :method => :any }

  map.connect 'quizzes/:id', :controller => 'quizzes', :action => 'show', :conditions => { :method => :get }
  map.connect 'quizzes/:id/:position', :controller => 'quizzes', :action => 'show', :conditions => { :method => :get }

  map.connect 'quizzes/:id', :controller => 'quizzes', :action => 'new', :conditions => { :method => :post }
  map.connect 'quizzes/:id/:position', :controller => 'quizzes', :action => 'submit_answers', :conditions => { :method => :post }

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "widgets", :action => "get_api_widget"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
