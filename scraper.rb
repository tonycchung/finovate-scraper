require 'capybara'
require 'capybara/poltergeist'

include Capybara::DSL
Capybara.default_driver = :poltergeist

visit "http://finovate.com/findevrsf14vid/"

all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
  puts td.first(:css, "a", {:visible => true}).text if td.has_css?("a")
end
