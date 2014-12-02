require 'capybara'
require 'capybara/poltergeist'
require 'csv'

include Capybara::DSL
Capybara.default_driver = :poltergeist
# Capybara.default_driver = :selenium

# Spring 2014
visit "http://www.finovate.com/spring14vid/"
shows = []

# Save each show, year, location and url in 'shows' gdbm
all(:css, "#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > div > table > tbody > tr > td").each do |td|
  if td.first(:css, "a", {visible: true})
    video_show = td.first(:css, "a").text
    show_year = "2014"
    location = "Spring"
    url = td.first(:css, "a", {:visible => true})["href"]

    shows << {
      video_show: video_show,
      show_year: show_year,
      location: location,
      url: url
    }
  end
end

CSV.open('spring2k14.csv', 'w') do |csv|
  csv << ["Video Show", "Show year", "Location", "url"]
  shows.each do |show|
    csv << [
        show[:video_show],
        show[:show_year],
        show[:location],
        show[:url]
      ]
  end
end
