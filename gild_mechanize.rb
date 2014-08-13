require 'mechanize'
require 'Nokogiri'
require 'pry'

agent = Mechanize.new
t = agent.get('http://www.gild.com/')
#binding.pry

puts t.inspect
