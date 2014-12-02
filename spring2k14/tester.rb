require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'gdbm'
# require 'sinatra'
# require 'rack/test'

include Capybara::DSL
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app)
end
Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :headers => { 'HTTP_USER_AGENT' => 'Capybara' })
end
Capybara.default_driver = :poltergeist
# Capybara.default_driver = :selenium

# Spring 2014
visit "http://www.finovate.com/spring14vid/artivest.html"

# all("#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > div > table > tbody > tr > td.cellpadding-left > p").each do |p|
#   puts p.find("strong").text
# end

puts within("#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > table > tbody > tr > td:nth-child(2) > p").html


# Key Executives: Justin Benson (CEO), Nathaniel Talbott (CTO)

# Key Investors: Emerge.be

# Key Partnerships: In mid 2013, Spreedly and Shopify teamed up to create the Gateway Index, an assessment of more than 50 popular payment gateways, where merchants and fintech solution providers can now come to compare gateway performance and determine which best meet their specific needs.

# Key Customers

# Key Board Members
