# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#case RAILS_ENV
#when "development"
#  ENV["kindlerock_app_path"] = "#{RAILS_ROOT}/../../kindlerock_lib/trunk"
#  ENV["quizresearch_app_path"] = "#{RAILS_ROOT}/../../quizresearch_lib/trunk"
#when "staging"
#  ENV["kindlerock_app_path"] = "#{RAILS_ROOT}/../../../kindlerock_lib/tags/4.0"
#  ENV["quizresearch_app_path"] = "#{RAILS_ROOT}/../../../quizresearch_lib/tags/4.0"
#else
  ENV["kindlerock_app_path"] = "#{RAILS_ROOT}/../kindlerock_lib"
  ENV["quizresearch_app_path"] = "#{RAILS_ROOT}/../quizresearch_lib"
#end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{ENV["kindlerock_app_path"]} )
  config.load_paths += %W( #{ENV["quizresearch_app_path"]}/app/models )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  #config.gem "typhoeus"
  #config.gem 'libxml-ruby', :lib => 'xml/libxml'
  #config.gem 'libxslt-ruby', :lib => 'libxslt'
  config.gem 'mechanize'
  config.gem 'authlogic'
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  require 'uuid'
  require "ruport" 
  require "ruport/acts_as_reportable"
end

require 'partner_system'
Dir.entries("#{ENV["quizresearch_app_path"]}/app/models").each do |file_name|
  next if file_name.eql?(".") or file_name.eql?("..") or file_name.eql?(".svn")
  require file_name
end
