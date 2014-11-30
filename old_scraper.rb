require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'gdbm'

include Capybara::DSL
# Capybara.default_driver = :poltergeist
Capybara.default_driver = :selenium

# Europe 2014
visit "http://www.finovate.com/europe14vid/"
shows = []

all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
  if td.first(:css, "a", {visible: true})
    video_show = td.first(:css, "a", {:visible => true}).text
    show_year = "2014"
    location = "Europe"
    url = td.first(:css, "a", {:visible => true})["href"]

    shows << {
      video_show: video_show,
      show_year: show_year,
      location: location,
      url: url
    }
  end
end

# shows.each do |show|
#   key_stats = ""
#   company_details = ""
#   visit "http://www.finovate.com/europe14vid/#{show[:url]}"

#   all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td.cellpadding-left p").each do |p|
#     company_details << p.text if p.has_text?("describe")
#     key_stats << p.text if p.has_text?("key") || p.has_text?("contact")
#   end
#   show[:key_stats] = key_stats
#   show[:company_details] = company_details
#   csv << [
#       show[:video_show],
#       show[:show_year],
#       show[:location],
#       show[:company_details],
#       show[:key_stats]
#     ]
# end

CSV.open('euro_test.csv', 'w') do |csv|
  csv << ["Video Show", "Show year", "Location", "Describe Themselves", "Describe Products", "Key Execs", "Key Partnerships", "Contacts"]
  shows.each do |show|
    next if show[:describe_themselves]

    describe_themselves = ""
    describe_products = ""
    key_execs = ""
    key_partnerships = ""
    contacts = ""
    visit "#{show[:url]}"

    all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td.cellpadding-left p").each do |p|
      describe_themselves << p.text if p.has_text?("How they describe themselves")
      describe_products << p.text if p.has_text?("How they describe their product")
      key_execs << p.text if p.has_text?("Key Executives")
      key_partnerships << p.text if p.has_text?("Key Partnerships")
      contacts << p.text if p.has_text?("Contacts")
    end

    show[:describe_themselves] = describe_themselves
    show[:describe_products] = describe_products
    show[:key_execs] = key_execs
    show[:key_partnerships] = key_partnerships
    show[:contacts] = contacts
    csv << [
        show[:video_show],
        show[:show_year],
        show[:location],
        show[:describe_themselves],
        show[:describe_products],
        show[:key_execs],
        show[:key_partnerships],
        show[:contacts]
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
