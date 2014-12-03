require 'capybara'
require 'capybara/poltergeist'
require 'csv'
require 'nokogiri'
require 'open-uri'
require 'gdbm'

class Scraper
  include Capybara::DSL
  Capybara.default_driver = :selenium

  attr_accessor :shows
  def initialize(show_name, year, location, main_url)
    Capybara.default_driver = :poltergeist
    @shows = GDBM.new("#{show_name}.db")
    @show_name = show_name
    @year = year
    @location = location
    @main_url = main_url
  end

  def get_shows(shows_td)
    visit "#{@main_url}"
    all(:css, "#{shows_td}").each do |td|
      if td.first(:css, "a", {visible: true})
        video_show = td.first(:css, "a").text
        url = td.first(:css, "a", {:visible => true})["href"]

        next if @shows[url]

        @shows[url] = JSON.dump(
          video_show: video_show,
          show_year: @year,
          location: @location,
          show_url: url
        )
      end
    end
  end

  def get_company_profile(css_details, css_profile)
    # Click through each show's link and save company details and key stats. Also save in gdbm so on restart don't overwrite ones already completed.
    @shows.each do |url, json|
      show = JSON.load(json)
      next if show["company_profile"]

      # Use nokogiri to get company details and company profile in raw HTML
      doc = Nokogiri::HTML(open("http://www.finovate.com/spring14vid/#{url}"))
      company_details = doc.css("#{css_details}").inner_html

      # Save entire company profile from td, add it line by line to company_profile until we've captured only necessary profile data
      # (nothing from and after "Product distribution strategy:")
      company_profile = ""
      profile = doc.css("#{css_profile}").inner_html
      profile.split("\n").each do |line|
        next if line.match(/presenter\s+profile/i)
        break if line.match(/product\s+distribution\s+strategy/i) || line.match(/Key/)
        company_profile << line
      end

      show["company_details"] = company_details
      show["company_profile"] = company_profile
      @shows[url] = JSON.dump(show)
    end
  end

  def get_key_stats(xpath_key_stats)
    @shows.each do |url, json|
      show = JSON.load(json)
      next if show["key_customers"]

      # Use capybara for rest of data
      key_execs = nil
      key_board_members = nil
      key_advisory_board_members = nil
      key_investors = nil
      key_partnerships = nil
      key_customers = nil

      # Go through every p tag in each td and save whichever key data it contains
      visit "#{url}"
      within(:css, "#{xpath_key_stats}") do
        all(:css, 'p').each do |p|
          p = p.text

          key_execs                  = sanitize_key(p) if p.match(/Key\s+Executives/i)
          key_board_members          = sanitize_key(p) if p.match(/Key\s+Board\s+Members/i)
          key_advisory_board_members = sanitize_key(p) if p.match(/Key\s+Advisory\s+Board\s+Members/i)
          key_investors              = sanitize_key(p) if p.match(/Key\s+Investors/i)
          key_partnerships           = sanitize_key(p) if p.match(/Key\s+Partnerships/i)
          key_customers              = sanitize_key(p) if p.match(/Key\s+Customers/i)
        end
      end

      # Reassign values in hash, dump JSON as value to url key in database
      show["key_execs"] = key_execs
      show["key_board_members"] = key_board_members
      show["key_advisory_board_members"] = key_advisory_board_members
      show["key_investors"] = key_investors
      show["key_partnerships"] = key_partnerships
      show["key_customers"] = key_customers
      shows[url] = JSON.dump(show)
    end
  end

  def output_csv
    # Write all data into CSV
    CSV.open("#{@show_name}.csv", 'w') do |csv|
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
        "Url"
      ]
      @shows.each do |url, json|
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
          show["url"]
        ]
      end
    end
  end

end

private
  def sanitize_key(string)
    # Key {anything here}: 'part, to, keep'
    arry = string.split(',')
    arry.first.each_char do |char|
      # arry.first = Key anything here}: part,
      if char == ':'
        arry.first.slice!(0,1)
        arry.first.lstrip!
        break
      end
      arry.first.slice!(0,1)
    end
    arry.join(',')
  end
