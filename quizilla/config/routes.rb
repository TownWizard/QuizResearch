ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'quizzes', :action => 'index'

  map.connect 'quizzes/test_create', :controller => 'quizzes', :action => 'test_create'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  #map.surveys '/surveys', :controller => 'publishers/surveys', :action => 'index'
  #map.connect '/surveys/:id', :controller => 'surveys', :action => 'index'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil

  map.resources :session
  #map.resource :user_session

  map.callback "/auth/:provider/callback", :controller => "surveys", :action => "start"
  map.failure "/auth/failure", :controller => "surveys", :action => "failure"
  map.setup "/auth/:provider/setup", :controller => "surveys", :action => "setup"
  
  map.resources :users

  map.publishers '/publishers', :controller => "publishers/index"

  
  map.resources :quizzes, :only => [ :show, :index ], :shallow => true do |quizzes|
    quizzes.resources :quiz_phases, :only => [ :show, :index ] do |quiz_phases|
      quiz_phases.resources :quiz_questions, :only => [ :show, :index ]
    end
  end

  map.resources :quizzes, :only => [ :show, :index ]

  # new survey routes?

  #TODO: using in a separate application, remove after verification
  #temporary routes for "page 0" of the synapse demos...
  map.connect 'surveys/synapse', :controller => 'surveys', :action => 'synapse'
  map.connect 'surveys/dressbarn', :controller => 'surveys', :action => 'dressbarn'
  map.connect 'surveys/petco', :controller => 'surveys', :action => 'petco'
  map.connect 'surveys/generic', :controller => 'surveys', :action => 'generic'
  map.connect 'surveys/signaturehomestyles', :controller => 'surveys', :action => 'signatureHomestyle'
  map.connect 'surveys/pamperedchef', :controller => 'surveys', :action => 'pamperedChef'
  map.connect 'surveys/tomboytools', :controller => 'surveys', :action => 'tomboyTools'
  map.connect 'surveys/redrobin', :controller => 'surveys', :action => 'redrobin'
  map.connect 'surveys/twe', :controller => 'surveys', :action => 'twe'
  map.connect 'surveys/marykay', :controller => 'surveys', :action => 'maryKay'
  map.connect 'surveys/jafra', :controller => 'surveys', :action => 'jafra'
  map.connect 'surveys/scentsy', :controller => 'surveys', :action => 'scentsy'
  map.connect 'surveys/fbm', :controller => 'surveys', :action => 'fbm'
  map.connect 'surveys/fbmibd', :controller => 'surveys', :action => 'fbmibd'
  map.connect 'surveys/new_era', :controller => 'surveys', :action => 'new_era'

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
  #TODO: using in a separate application, remove after verification -- END

  # new versioned routes
  map.connect 'quizzes/v/:version', :controller => 'quizzes', :action => 'index'

  map.connect 'quizzes/v/:version/open/new', :controller => 'quiz_instances', :action => 'create', :conditions => { :method => :post }
  
  map.connect 'quizzes/v/:version/open/:qiid', :controller => 'quiz_instances', :action => 'show', :conditions => { :method => :get }
  map.connect 'quizzes/v/:version/open/:qiid/:ppos', :controller => 'quiz_instances', :action => 'show', :conditions => { :method => [ :get ] }

  map.connect 'quizzes/v/:version/open/:qiid/:ppos', :controller => 'quiz_instances', :action => 'submit_answers', :conditions => { :method => [ :post ] }
  map.connect 'quizzes/v/:version/open/:qiid', :controller => 'quiz_instances', :action => 'submit_answers', :conditions => { :method => :post }

  map.connect 'quizzes/v/:version/:id', :controller => 'quizzes', :action => 'show', :conditions => { :method => :get }
  # end versioned routes
  map.connect 'assessments/show/:qiid', :controller => 'assessments', :action => 'show'

  map.connect 'quizzes/open/new', :controller => 'quiz_instances', :action => 'create', :conditions => { :method => :post }

  map.connect 'quizzes/open/:qiid', :controller => 'quiz_instances', :action => 'show', :conditions => { :method => :get }
  map.connect 'quizzes/open/:qiid/:ppos', :controller => 'quiz_instances', :action => 'show', :conditions => { :method => [ :get ] }

  map.connect 'quizzes/open/:qiid/:ppos', :controller => 'quiz_instances', :action => 'submit_answers', :conditions => { :method => [ :post ] }
  map.connect 'quizzes/open/:qiid', :controller => 'quiz_instances', :action => 'submit_answers', :conditions => { :method => :post }

  map.connect 'quizzes/completed', :controller => 'quiz_instances', :action => 'list_assessments', :conditions => { :method => :get }
  map.connect 'quizzes/completed/:qiid', :controller => 'assessments', :action => 'show', :conditions => { :method => [ :get, :delete ] }

  # get me a new anonymous quiz based on partner site category
  map.connect 'quizzes/category/p/:category_identifier', :controller => 'quizzes', :action => 'get_by_partner_category'

  # get me a new anonymous quiz based on global quiz categories
  map.connect 'quizzes/category/g/:category_identifier', :controller => :quizzes, :action => :get_by_global_category

  map.connect 'quizzes/user/:user_id', :controller => :quizzes, :action => :get_by_user_id
  map.connect 'quizzes/categories/:category_identifier/', :controller => 'quizzes', :action => 'index'
  #map.connect 'quizzes/categories/:category_identifier/users/:user_id', :controller => 'quizzes', :action => 'get_by_category_and_user'

  map.connect 'quizzes/categories', :controller => 'quiz_categories', :action => 'index', :conditions => { :method => :get }
  map.connect 'quizzes/categories/:id', :controller => 'quiz_categories', :action => 'show', :conditions => { :method => :get }

  map.connect 'quizzes/start/:id', :controller => 'quizzes', :action => 'show', :conditions => { :method => :get }
  
  

  map.namespace( :publishers ) do |publishers|

    publishers.resources( :quizzes,
      :belongs_to => :quiz_category,
      :has_many => [ :quiz_phases, :quiz_recommendations, :quiz_lead_answers ],
      :member => { :toggle_phase => :get, :toggle_phase_quesion => :get, :toggle_phase_quesion_answer => :get, :toggle_recommendation => :get, :get_data => :get }
    )

    publishers.resources( :surveys,
      :belongs_to => :quiz
    )

    publishers.resources( :quiz_phases,
      :belongs_to => :quiz, :has_many => :quiz_questions )

    publishers.resources( :quiz_questions,
      :belongs_to => :quiz_phase, :has_many => :quiz_answers )

    publishers.resources( :quiz_answers,
      :belons_to => :quiz_question, :has_many => :quiz_learning_blurbs )

    publishers.resources( :quiz_recommendations,
      :belongs_to => :quiz, :has_many => :affiliate_product_quiz_recommendation_bindings )

    publishers.resources( :quiz_categories,
      :has_many => [ :quizzes, :quiz_lead_questions ]
    )

    publishers.resources( :quiz_lead_questions,
      :belongs_to => :quiz_category, :has_many => :quiz_lead_answers
    )

    publishers.resources( :quiz_lead_answers,
      :belongs_to => :quiz_lead_question, :belongs_to => :quiz
    )

    publishers.namespace( :reports ) do |reports|
      reports.resources :surveys_report, :except => [ :create, :destroy, :edit, :new, :update ]
    end

    publishers.resources :users
    publishers.resources :partner_sites, :member => { :show_quizzes => :get, :save => :post }
    publishers.resources :partner_categories
    publishers.resources :partner_site_categories, :member => { :show_quiz_categories => :get, :save => :post }
    publishers.resources :widgets, :collection => {:update_quiz_list => :get}
  end

  map.namespace( :houston ) do |houston|
    houston.resources :cobrand_groups
  end
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
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
