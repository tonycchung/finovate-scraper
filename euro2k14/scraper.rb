require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'nokogiri'
require 'open-uri'
require 'gdbm'

# Capybara.default_driver = :poltergeist
Capybara.default_driver = :selenium

# Europe 2014
visit "http://www.finovate.com/europe14vid/"
shows = GDBM.new("shows.db")

show_year = "2014"
location = "Europe"

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
  next if show["company_details"]

  # Use nokogiri to get company details and company profile in raw HTML
  doc = Nokogiri::HTML(open("#{url}"))
  company_details = doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > table > tr > td:nth-child(2) > p').inner_html

  profile = nokogiri_page.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > table > tr > td.cellpadding-left').inner_html
  company_profile = []
  profile.split("\n").each do |line|
    if line.include?("Product distribution strategy")
      company_profile.pop
      company_profile.shift
      company_profile.join
      break
    end
    company_profile << line
  end

  # Use capybara for rest of data
  key_execs = ""
  key_board_members = ""
  key_investors = ""
  key_partnerships = ""
  key_customers = ""
  describe_selves = ""
  describe_product = ""

  visit "#{url}"
  has_content?(show["video_show"]) or raise "couldn't load #{url}"

  # Go through every p tag in each td and save whichever key data it contains
  within(:xpath, '//table/tbody/tr/td/table[2]/tbody/tr/td/div/table/tbody/tr/td[1]') do
    all(:xpath, './/p').each do |p|
      p = p.text

      key_execs = p.match(/([^Key Executives: ]).*/).to_s if p.include?("Key Executives")
      key_board_members = p.match(/([^Key Board Members: ]).*/).to_s if p.include?("Board Members")
      key_investors = p.match(/([^Key Investors: ]).*/).to_s if p.include?("Key Investors")
      key_customers = p.match(/([^Key Customers: ]).*/).to_s if p.include?("Key Customers")
      key_partnerships = p.match(/([^Key Partnerships: ]).*/).to_s if p.include?("Key Partnerships")
    end
  end

  # Reassign values in hash, dump JSON as value to url key in database
  show["company_details"] = company_details
  show["company_profile"] = company_profile
  show["key_execs"] = key_execs
  show["key_board_members"] = key_board_members
  show["key_investors"] = key_investors
  show["key_partnerships"] = key_partnerships
  show["key_customers"] = key_customers

  shows[url] = JSON.dump(show)
end

# Write all data into CSV
CSV.open('euro2k14.csv', 'w') do |csv|
  csv << [
    "Video Show",
    "Show year",
    "Location",
    "Company Details",
    "Company Profile",
    "Key_stats",
    "Key_execs",
    "Key_board_members",
    "Key_investors",
    "Key_partnerships",
    "Key_customers",
    "Url"
  ]
  shows.each do |url, json|
    show = JSON.load(json)
    csv << [
      show["video_show"],
      show["show_year"],
      show["location"],
      show["company_details"],
      show["company_profile"],
      show["key_stats"],
      show["key_execs"],
      show["key_board_members"],
      show["key_investors"],
      show["key_partnerships"],
      show["key_customers"],
      show["url"]
    ]
  end
end
