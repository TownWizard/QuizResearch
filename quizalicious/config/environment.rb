# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#case RAILS_ENV
#when "development"
#  ENV["kindlerock_app_path"] = "#{RAILS_ROOT}/../../kindlerock_lib/trunk"
#  ENV["quizresearch_app_path"] = "#{RAILS_ROOT}/../../quizresearch_lib/trunk"
#when "staging"
#  ENV["kindlerock_app_path"] = "#{RAILS_ROOT}/../../../kindlerock_lib/tags/4.0.1"
#  ENV["quizresearch_app_path"] = "#{RAILS_ROOT}/../../../quizresearch_lib/tags/4.0.1"
#else
  ENV["kindlerock_app_path"] = "#{RAILS_ROOT}/../kindlerock_lib"
  ENV["quizresearch_app_path"] = "#{RAILS_ROOT}/../quizresearch_lib"
#end
ENV["fb_app_name"] = "quizalicious"

Rails::Initializer.run do |config|
  config.load_paths += %W( #{ENV["kindlerock_app_path"]} )
  config.load_paths += %W( #{ENV["quizresearch_app_path"]}/app/models )
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir|
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end

  config.gem 'acts_as_list', :version => '0.1.3'
  
  config.gem "mogli", :version => "0.0.24"
  config.gem "facebooker2", :version => "0.0.11", :lib => false
  config.gem "ruby-hmac", :version => "0.4.0", :lib => false
  config.gem 'mechanize'
  config.gem "ruport"

  config.time_zone = 'UTC'
#  config.action_controller.session = {
#    :key    => '_quizalicious_session',
#    :secret => '92df688910cd176a218bddcb2fe857b69b497d3c4d2e900fe6152951fe24a406aa2c48e9154211affa66aaab625a9536ba00a04f3c6a74e007cdfd43bd9b355d'
#  }
  require 'uuid'
end
