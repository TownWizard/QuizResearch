ActionController::Routing::Routes.draw do |map|
  map.callback "/auth/:provider/callback", :controller => "surveys", :action => "start"
  map.failure "/auth/failure", :controller => "surveys", :action => "failure"
  map.setup "/auth/:provider/setup", :controller => "surveys", :action => "setup"

  #temporary routes for "page 0" of the synapse demos...
  map.connect 'synapse', :controller => 'surveys', :action => 'synapse'
  map.connect 'dressbarn', :controller => 'surveys', :action => 'dressbarn'
  map.connect 'petco', :controller => 'surveys', :action => 'petco'
  map.connect 'generic', :controller => 'surveys', :action => 'generic'
  map.connect 'signaturehomestyles', :controller => 'surveys', :action => 'signatureHomestyle'
  map.connect 'pamperedchef', :controller => 'surveys', :action => 'pamperedChef'
  map.connect 'tomboytools', :controller => 'surveys', :action => 'tomboyTools'
  map.connect 'redrobin', :controller => 'surveys', :action => 'redrobin'
  map.connect 'twe', :controller => 'surveys', :action => 'twe'
  map.connect 'marykay', :controller => 'surveys', :action => 'marykay'
  map.connect 'jafra', :controller => 'surveys', :action => 'jafra'
  map.connect 'scentsy', :controller => 'surveys', :action => 'scentsy'
  map.connect 'fbm', :controller => 'surveys', :action => 'fbm'
  map.connect 'fbm2', :controller => 'surveys', :action => 'fbm2'
  map.connect 'fbmibd', :controller => 'surveys', :action => 'fbmibd'
  map.connect 'avon', :controller => 'surveys', :action => 'avon'
  map.connect 'massmark', :controller => 'surveys', :action => 'massmark'
  map.connect 'massmarkold', :controller => 'surveys', :action => 'massmarkold'
  map.connect 'new_era', :controller => 'surveys', :action => 'new_era'
  map.connect 'amfam', :controller => 'surveys', :action => 'amfam'

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

  #TODO: Temporary commenting this line
#  map.connect '*path', :controller => 'surveys', :action => 'index'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

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
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
