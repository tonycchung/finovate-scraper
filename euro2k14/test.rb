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

url = "http://www.finovate.com/europe14vid/avoka.html"
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
key_investors = ""
key_partnerships = ""
key_customers = ""
visit "#{url}"

within(:css, '#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > div > table > tbody > tr > td.cellpadding-left') do
  all(:xpath, './/p').each do |p|
    p = p.text

    # describe_selves << "\n" + p.text unless p.find(:xpath, './/strong')
    # describe_product = p.find(:xpath, ".//text()") if p.include?("how they describe their product")

    key_execs = p.match(/([^Key Executives: ]).*/).to_s if p.include?("Key Executives")
    key_board_members = p.match(/([^Key Board Members: ]).*/).to_s if p.include?("Key Board Members")
    key_investors = p.match(/([^Key Investors: ]).*/).to_s if p.include?("Key Investors")
    key_customers = p.match(/([^Key Customers: ]).*/).to_s if p.include?("Key Customers")
    key_partnerships = p.match(/([^Key Partnerships: ]).*/).to_s if p.include?("Key Partnerships")
  end
end

puts key_execs
puts key_board_members
puts key_investors
puts key_partnerships
puts key_customers
puts company_description
puts new_profile
