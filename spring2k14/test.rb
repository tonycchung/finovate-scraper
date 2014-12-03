require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'nokogiri'
require 'open-uri'

include Capybara::DSL
Capybara.default_driver = :poltergeist
# Capybara.default_driver = :selenium

def sanitize_key(string)
  arry = string.split(',')
  arry.first.each_char do |char|
    arry.first.slice!(0,1)
    if char == ':'
      arry.first.slice!(0,1)
      break
    end
  end
  arry.join(', ')
end

site_url = "http://www.finovate.com/spring14vid/"
test_url = "http://www.finovate.com/spring14vid/artivest.html"
shows_td = "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td"
css_details = "#contentwrapper table tr td table:nth-child(3) tr td table tr td:nth-child(2) p"
css_profile = "#contentwrapper table tr td table:nth-child(3) tr td div table tr td.cellpadding-left"
css_key_stats = "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td.cellpadding-left"

visit "#{site_url}"
all(:css, "#{shows_td}").each do |td|
  if td.first(:css, "a", {visible: true})
    video_show = td.first(:css, "a").text
    url = td.first(:css, "a", {:visible => true})["href"]
  end
end

doc = Nokogiri::HTML(open("#{test_url}"))
company_details = doc.css("#{css_details}").inner_html

company_profile = ""
profile = doc.css("#{css_profile}").inner_html
profile.split("\n").each do |line|
  next if line.match(/presenter\s+profile/i)
  break if line.match(/product\s+distribution\s+strategy/i) || line.match(/Key/)
  company_profile << line
end

puts company_profile
puts company_details

CSV.open('test_gen.csv', 'w') do |csv|
  csv << ['details', 'profile']
  csv << [company_details, company_profile]
end

key_execs = nil
key_board_members = nil
key_advisory_board_members = nil
key_investors = nil
key_partnerships = nil
key_customers = nil

visit "#{test_url}"

# Go through every p tag in each td and save whichever key data it contains
within(:xpath, '//table/tbody/tr/td/table[2]/tbody/tr/td/div/table/tbody/tr/td[1]') do
  all(:xpath, './/p').each do |p|
    p = p.text

    key_execs                  = sanitize_key(p) if p.match(/Key\s+Executives/i)
    key_board_members          = sanitize_key(p) if p.match(/Key\s+Board\s+Members/i)
    key_advisory_board_members = sanitize_key(p) if p.match(/Key\s+Advisory\s+Board\s+Members/i)
    key_investors              = sanitize_key(p) if p.match(/Key\s+Investors/i)
    key_partnerships           = sanitize_key(p) if p.match(/Key\s+Partnerships/i)
    key_customers              = sanitize_key(p) if p.match(/Key\s+Customers/i)
  end
end

puts key_execs
puts key_board_members
puts key_advisory_board_members
puts key_investors
puts key_partnerships
puts key_customers


