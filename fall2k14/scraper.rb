require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'nokogiri'
require 'open-uri'
require 'gdbm'

include Capybara::DSL
# Capybara.default_driver = :poltergeist
Capybara.default_driver = :selenium

# Spring 2014
shows = GDBM.new("shows.db")
visit "http://www.finovate.com/fall14vid/"

show_year = "2014"
location = "Fall"

def sanitize_key(string)
  # Key {anything here}: 'part, to, keep'
  arry = string.split(',')
  arry.first.each_char do |char|
    # arry.first = Key anything here}: part,
    if char == ':'
      tmp = arry.first.slice!(0,1)
      arry.first.lstrip!
      break
    end
    arry.first.slice!(0,1)
  end
  arry.join(',')
end

def sanitize_prod_dist(string)
  result = string.match(/[^product\s+distribution\s+strategy].*/i).to_s
  result.slice!(0,1)
  result.lstrip!
  result
end

# Save each show, year, location and url in 'shows' gdbm
all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
  if td.first(:css, "a", {visible: true})
    video_show = td.first(:css, "a").text
    url = td.first(:css, "a", {:visible => true})["href"]

    next if shows[url]

    shows[url] = JSON.dump(
      video_show: video_show,
      show_year: show_year,
      location: location,
      url: url
    )
  end
end

# Click through each show's link and save company details and key stats. Also save in gdbm so on restart don't overwrite ones already completed.
shows.each do |url, json|
  show = JSON.load(json)
  # next if show["contacts"]

  # Use nokogiri to get company details and company profile in raw HTML
  doc = Nokogiri::HTML(open("#{url}"))
  company_details = doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > table > tr > td:nth-child(2)').inner_html

  # Save entire company profile from td, add it line by line to company_profile until we've captured only necessary profile data
  # (nothing from and after "Product distribution strategy:")
  visit "#{url}"
  company_profile = ""
  if page.has_selector?(:css, '#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > div > table > tbody > tr > td.cellpadding-left')
    profile = doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > table > tr > td.cellpadding-left').inner_html
  else
    profile = doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > div > table > tr > td.cellpadding-left').inner_html
  end

  profile.split("\n").each do |line|
    next if line.match(/presenter\s+profile/i)
    break if line.match(/product\s+distribution\s+strategy/i) || line.match(/Key/)
    company_profile << line
  end

  # # Use capybara for rest of data
  # logo = ''
  # logo_url = ''
  # within(:css, "#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > table > tbody > tr > td:nth-child(1) > div") do
  #   all(:css, 'a').each do |a|
  #     logo = a.find('img')['src']
  #     logo_url = a['href']
  #   end
  # end

  # has_content?(show["video_show"]) or raise "couldn't load #{url}"

  # contacts = nil
  # product_dist_strat = nil
  # key_execs = nil
  # key_board_members = nil
  # key_advisory_board_members = nil
  # key_investors = nil
  # key_partnerships = nil
  # key_customers = nil

  # # Go through every p tag in each td and save whichever key data it contains
  # if page.has_selector?(:xpath, '//table/tbody/tr/td/table[2]/tbody/tr/td/div/table/tbody/tr/td[1]')
  #   key_xpath = '//table/tbody/tr/td/table[2]/tbody/tr/td/div/table/tbody/tr/td[1]'
  # else
  #   key_xpath = '//table/tbody/tr/td/table[2]/tbody/tr/td/div/div/table/tbody/tr/td[1]'
  # end

  # contacts_key_path = key_xpath.split('/').reject {|e| e == 'tbody'}.join('/')

  # within(:xpath, key_xpath) do
  #   count = 0
  #   all(:xpath, './/p').each do |p|
  #     count += 1
  #     p = p.text

  #     contacts = doc.xpath(contacts_key_path + "/p[#{count}]").inner_html if p.match /Contacts:/
  #     product_dist_strat         = sanitize_prod_dist(p) if p.match(/product\s+distribution\s+strategy/i)
  #     key_execs                  = sanitize_key(p)       if p.match(/Key\s+Executives/i)
  #     key_board_members          = sanitize_key(p)       if p.match(/Key\s+Board\s+Members/i)
  #     key_advisory_board_members = sanitize_key(p)       if p.match(/Key\s+Advisory\s+Board\s+Members/i)
  #     key_investors              = sanitize_key(p)       if p.match(/Key\s+Investors/i)
  #     key_partnerships           = sanitize_key(p)       if p.match(/Key\s+Partnerships/i)
  #     key_customers              = sanitize_key(p)       if p.match(/Key\s+Customers/i)
  #   end
  # end

  # Reassign values in hash, dump JSON as value to url key in database
  # show["company_details"] = company_details
  show["company_profile"] = company_profile
  # show["contacts"] = contacts
  # show["product_dist_strat"] = product_dist_strat
  # show["key_execs"] = key_execs
  # show["key_board_members"] = key_board_members
  # show["key_advisory_board_members"] = key_advisory_board_members
  # show["key_investors"] = key_investors
  # show["key_partnerships"] = key_partnerships
  # show["key_customers"] = key_customers
  # show["logo"] = logo
  # show["logo_url"] = logo_url
  shows[url] = JSON.dump(show)
end

# Write all data into CSV
CSV.open('fall2k14.csv', 'w') do |csv|
  csv << [
    "Video Show",
    "Show year",
    "Location",
    "Key Execs",
    "Key Board Members",
    "Key Advisory Board Members",
    "Key Investors",
    "Key Partnerships",
    "Key Customers",
    "Company Details",
    "Company Profile",
    "Product Distribution Strategy",
    "Contacts",
    "Url",
    "Logo",
    "Logo URL"
  ]
  shows.each do |url, json|
    show = JSON.load(json)
    csv << [
      show["video_show"],
      show["show_year"],
      show["location"],
      show["key_execs"],
      show["key_board_members"],
      show["key_advisory_board_members"],
      show["key_investors"],
      show["key_partnerships"],
      show["key_customers"],
      show["company_details"],
      show["company_profile"],
      show["product_dist_strat"],
      show["contacts"],
      show["url"],
      show["logo"],
      show["logo_url"],
    ]
  end
end
