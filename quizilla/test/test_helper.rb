ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'sham'
require 'faker'
require 'shoulda'
class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  require 'shoulda'
  
  Sham.define do
    Sham.label { Faker::Lorem.sentence }
    Sham.text { Faker::Lorem.paragraphs }
    Sham.position { |index| "#{index}" }
    Sham.email { Faker::Internet.email }
  end

  require 'factory_girl'
  # all facotry definitions live in test/factories.rb.
  Factory.find_definitions

  # Add more helper methods to be used by all tests here...
  setup { Sham.reset }

  require 'mocha'

  def set_quiz_mocks
    QuizCategory.any_instance.stubs( :index_document ).returns( :true )
    Quiz.any_instance.stubs( :index_document ).returns( :true )
    QuizPhase.any_instance.stubs( :index_document ).returns( :true )
    QuizQuestion.any_instance.stubs( :index_document ).returns( :true )
    QuizAnswer.any_instance.stubs( :index_document ).returns( :true )
    QuizLeadAnswer.any_instance.stubs( :index_document ).returns( :true )
    QuizLearningBlurb.any_instance.stubs( :index_document ).returns( :true )
  end
  
end

