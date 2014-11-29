require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'gdbm'

include Capybara::DSL
Capybara.default_driver = :poltergeist

# Europe 2014
visit "http://www.finovate.com/europe14vid/"

CSV do |csv|
  csv << ["Video Show", "Show year", "Location", "Url"]

  all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
    video_show = td.first(:css, "a", {:visible => true}).text
    show_year = "2014"
    location = "Europe"
    url = td.first(:css, "a", {:visible => true})["href"] if td.first(:css, "a", {visible: true})

    csv << [video_show, show_year, location, url]
  end
end
