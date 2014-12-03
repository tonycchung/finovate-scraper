require 'oo_scraper'

show_name = 'spring2k14'
year = 2014
location = 'spring'
url = 'http://www.finovate.com/spring14vid/'
shows_td =
css_details =
css_profile =
css_key_stats =

scraper = Scraper.new(show_name, year, location, url)
scraper.get_shows(shows_td)
scraper.get_company_profile(css_details, css_profile)
scraper.get_key_stats(css_key_stats)
scraper.output_csv
