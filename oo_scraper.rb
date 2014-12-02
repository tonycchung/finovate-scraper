require 'capybara'
require 'capybara/poltergeist'
require 'csv'

class Scraper
  include Capybara::DSL

  def initialize(year, location)
    Capybara.default_driver = :poltergeist
    @shows = []
    @year = year
    @location = location
  end

  def scrape(site, td)
    visit site
    all(:css, td).each do |td|
      if td.first(:css, "a", {visible: true})
        video_show = td.first(:css, "a").text
        url = td.first(:css, "a", {:visible => true})["href"]

        @shows << {
          video_show: video_show,
          show_year: @year,
          location: @location,
          url: url
        }
      end
    end
  end

  def output_csv(filename)
    CSV.open("#{filename}.csv", 'w') do |csv|
      csv << ["Video Show", "Show year", "Location", "url"]
      @shows.each do |show|
        csv << [
            show[:video_show],
            show[:show_year],
            show[:location],
            show[:url]
          ]
      end
    end
  end
end
