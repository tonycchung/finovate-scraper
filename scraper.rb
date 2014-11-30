require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'gdbm'
require 'sinatra'
require 'rack/test'

include Capybara::DSL
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:timeout => 5})
end
Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :headers => { 'HTTP_USER_AGENT' => 'Capybara' })
end
# Capybara.default_driver = :poltergeist
# Capybara.default_driver = :selenium

# Europe 2014
visit "http://www.finovate.com/europe14vid/"
shows = GDBM.new("shows.db")

# Save each show, year, location and url in 'shows' gdbm
all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td").each do |td|
  if td.first(:css, "a", {visible: true})
    video_show = td.first(:css, "a").text
    show_year = "2014"
    location = "Europe"
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

# Click through each show's link and save company details and key stats data
shows.each do |url, json|
  show = JSON.load(json)

  next if show["key_stats"].size > 0
  key_stats = ""
  company_details = ""

  # if url.match(/finovate/)
    site = "#{url}"
  # else
  #   site = "http://www.finovate.com/europe14vid/#{url}"
  # end

  visit site
  has_content?(show["video_show"]) or raise "couldn't load #{url}"
  all(:css, "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td.cellpadding-left p").each do |p|
    company_details << p.text if p.has_text?("describe")
    key_stats << p.text if p.has_text?("Key") || p.has_text?("Contacts")
  end
  show["key_stats"] = key_stats
  show["company_details"] = company_details
  shows[url] = JSON.dump(show)
end

# Write all data into CSV
CSV.open('euro2k14.csv', 'w') do |csv|
  csv << ["Video Show", "Show year", "Location", "Company details", "Key stats", "Url"]
  shows.each do |url, json|
    show = JSON.load(json)
    csv << [
      show["video_show"],
      show["show_year"],
      show["location"],
      show["company_details"],
      show["key_stats"],
      show["url"]
    ]
  end
end
