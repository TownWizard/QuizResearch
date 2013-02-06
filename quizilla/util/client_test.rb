require 'rubygems'
#require 'httparty'
  require 'uri'
  require 'net/http'
  
  require 'open-uri'

#conn = Net::HTTP.start( url.host, url.port )

#require 'net/http'

#url = URI.parse("http://localhost:3000/quizzes/category/p/General?format=xml" )
#1000.times do

#end
 require 'rubygems'
 require 'mechanize'

 agent = WWW::Mechanize.new

1000.times do
   page = agent.get('http://localhost:3000/quizzes/category/p/General?format=xml')
end


#1000.times do
#  open( "http://localhost:3000/quizzes/category/p/General?format=xml" )
#end
#class Local
#  include HTTParty
#
#end


#1000.times do |i|
#  Local.get( "http://localhost:3000/quizzes/category/p/General?format=xml" )
#end

