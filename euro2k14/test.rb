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

def sanitize_prod_dist(string)
  result = string.match(/[^product\s+distribution\s+strategy].*/i).to_s
  result.slice!(0,1)
  result.lstrip!
  result
end

url = "http://www.finovate.com/europe14vid/temenos.html"
nokogiri_page = Nokogiri::HTML(open("#{url}"))
company_description = nokogiri_page.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > table > tr > td:nth-child(2) > p').inner_html

company_profile = ""
profile = nokogiri_page.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > table > tr > td.cellpadding-left').inner_html
profile.split("\n").each do |line|
  next if line.match(/presenter\s+profile/i)
  break if line.match(/product\s+distribution\s+strategy/i) || line.match(/Key/)
  company_profile << line
end

image = nokogiri_page.css('#contentwrapper table tr td table:nth-child(3) tr td table tr td:nth-child(1) div a img')

contacts = nil
product_dist_strat = nil
key_execs = nil
key_board_members = nil
key_advisory_board_members = nil
key_investors = nil
key_partnerships = nil
key_customers = nil

visit "#{url}"
# Save company logo
logo = ''
visit "#{url}"
within(:css, "#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > table > tbody > tr > td:nth-child(1) > div") do
  all(:css, 'a').each do |a|
    logo = a.find('img')['src']
  end
end

# Go through every p tag in each td and save whichever key data it contains
within(:xpath, '//table/tbody/tr/td/table[2]/tbody/tr/td/div/table/tbody/tr/td[1]') do
  count = 0
  all(:xpath, './/p').each do |p|
    count += 1
    p = p.text

    contacts = nokogiri_page.xpath("//table/tr/td/table[2]/tr/td/div/table/tr/td[1]/p[#{count}]").inner_html if p.match /Contacts:/
    product_dist_strat         = sanitize_prod_dist(p) if p.match(/product\s+distribution\s+strategy/i)
    key_execs                  = sanitize_key(p) if p.match(/Key\s+Executives/i)
    key_board_members          = sanitize_key(p) if p.match(/Key\s+Board\s+Members/i)
    key_advisory_board_members = sanitize_key(p) if p.match(/Key\s+Advisory\s+Board\s+Members/i)
    key_investors              = sanitize_key(p) if p.match(/Key\s+Investors/i)
    key_partnerships           = sanitize_key(p) if p.match(/Key\s+Partnerships/i)
    key_customers              = sanitize_key(p) if p.match(/Key\s+Customers/i)
  end
end

puts contacts
puts product_dist_strat
# puts key_execs
# puts key_board_members
# puts key_advisory_board_members
# puts key_investors
# puts key_partnerships
# puts key_customers


