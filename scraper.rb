require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'gdbm'

include Capybara::DSL
Capybara.default_driver = :poltergeist

# Europe 2014
visit "http://www.finovate.com/europe14vid/"
shows = []

all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
  video_show = td.first(:css, "a", {:visible => true}).text
  show_year = "2014"
  location = "Europe"
  url = title = td.first(:css, "a", {:visible => true})["href"]

  shows << {
    video_show: video_show,
    show_year: show_year,
    location: location,
    url: url
  }
end

shows.each do |show|
  visit "http://www.finovate.com/europe14vid/#{show[:url]}"
  all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td.cellpadding-left").each do |p|
    key_stats = ""
    company_details = ""
    company_details << p if p.has_text?("describe")
    key_stats << p if p.has_text?("key")
  end
  show[:key_stats] = key_stats
end

CSV do |csv|
  csv << ["Video Show", "Show year", "Location", "Company details", "Key stats"]
  shows.each do |show|
    csv << [
      show[:video_show],
      show[:show_year],
      show[:location],
      show[:company_details],
      show[:key_stats]
    ]
  end
end

#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > div > table > tbody > tr > td.cellpadding-left > p:nth-child(1)
#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > div > table > tbody > tr > td.cellpadding-left > p:nth-child(2)
#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > div > table > tbody > tr > td.cellpadding-left > p:nth-child(3)
# visit "http://finovate.com/findevrsf14vid/"

# Spring SF 2014
# all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
#   if td.has_css?("a")
#     hsh = {}
#     link = td.first(:css, "a", {:visible  true})
#     hsh[:show] = link
#     link.click


#   end
# end

#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr:nth-child(1)
=begin
Company Details
#contentwrapper table tbody tr td table:nth-child(3) tbody tr td table tbody tr td:nth-child(2) p
#contentwrapper table tbody tr td table:nth-child(3) tbody tr td table tbody tr td:nth-child(2) p

//*[@id="contentwrapper"]/table/tbody/tr/td/table[2]/tbody/tr/td/div/table/tbody/tr/td[1]/text()
//*[@id="contentwrapper"]/table/tbody/tr/td/table[2]/tbody/tr/td/div/table/tbody/tr/td[1]/text()[1]


=end
