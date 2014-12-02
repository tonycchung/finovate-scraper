require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'nokogiri'
require 'open-uri'

include Capybara::DSL
Capybara.default_driver = :poltergeist
# Capybara.default_driver = :selenium

# Europe 2014
# visit "http://www.finovate.com/europe14vid/"

# CSV.open('test.csv', 'w') do |csv|
#   csv << ["Video Show", "Show year", "Location", "Url"]

#   all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
#     if td.first(:css, "a", {visible: true})
#       video_show = td.first(:css, "a", {:visible => true}).text
#       show_year = "2014"
#       location = "Europe"
#       url = td.first(:css, "a", {:visible => true})["href"]
#       csv << [video_show, show_year, location, url]
#     end
#   end
# end


# visit "http://www.finovate.com/europe14vid/"
# shows = []

# all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
#   video_show = td.first(:css, "a", {:visible => true}).text
#   show_year = "2014"
#   location = "Europe"
#   url = td.first(:css, "a", {:visible => true})["href"] if td.first(:css, "a", {visible: true})

#   shows << {
#     video_show: video_show,
#     show_year: show_year,
#     location: location,
#     url: url
#   }
# end

# shows.each do |show|
#   visit "http://www.finovate.com/europe14vid/#{show[:url]}"
#   puts show[:video_show]
#   puts first(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td.cellpadding-left p").text
#   puts first(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td.cellpadding-left p").has_text?("describe")
# end

url = "http://www.finovate.com/europe14vid/meniga.html"
nokogiri_page = Nokogiri::HTML(open("#{url}"))
company_description = nokogiri_page.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > table > tr > td:nth-child(2) > p').inner_html
company_profile = nokogiri_page.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > table > tr > td.cellpadding-left').inner_html
new_profile = []
company_profile.split("\n").each do |tag|
  if tag.include?("Product distribution strategy")
    new_profile.pop if new_profile.last.include?("<p>")
    new_profile.shift if new_profile.first.include?("Presenter Profile")
    new_profile.join
    break
  end
  new_profile << tag
end

key_execs = ""
key_board_members = ""
key_advisory_board_members = ""
key_investors = ""
key_partnerships = ""
key_customers = ""

visit "#{url}"
has_content?(show["video_show"]) or raise "couldn't load #{url}"

# Go through every p tag in each td and save whichever key data it contains
within(:xpath, '//table/tbody/tr/td/table[2]/tbody/tr/td/div/table/tbody/tr/td[1]') do
  all(:xpath, './/p').each do |p|
    all(:xpath, './/strong').each do |strong|

    strong = strong.text

    key_execs                  = strong.match(/([^Key\s+Executives: ]).*/).to_s if strong.include?("Key Executives")
    key_board_members          = strong.match(/([^Key\s+Board\s+Members: ]).*/).to_s if strong.include?("Key Board Members")
    key_advisory_board_members = strong.match(/([^Key\s+Advisory\s+Board\s+Members: ]).*/).to_s if strong.include?("Key Advisory Board Members")
    key_investors              = strong.match(/([^Key\s+Investors: ]).*/).to_s if strong.include?("Key Investors")
    key_partnerships           = strong.match(/([^Key\s+Partnerships: ]).*/).to_s if strong.include?("Key Partnerships")
    key_customers              = strong.match(/([^Key\s+Customers: ]).*/).to_s if strong.include?("Key Customers")
  end
end

puts key_execs
puts key_board_members
puts key_advisory_board_members
puts key_investors
puts key_partnerships
puts key_customers
