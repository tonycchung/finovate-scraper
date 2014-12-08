require_relative '../oo_scraper'

show_name = 'spring2k14'
year = 2014
location = 'spring'
url = 'http://www.finovate.com/spring14vid/'
shows_td = "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td"
css_details = "#contentwrapper table tr td table:nth-child(3) tr td table tr td:nth-child(2) p"
css_profile = "#contentwrapper table tr td table:nth-child(3) tr td div table tr td.cellpadding-left"
xpath_key_stats = "#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td.cellpadding-left"

scraper = Scraper.new(show_name, year, location, url)
p "getting shows"
scraper.get_shows(shows_td)

p "getting profile"
scraper.get_company_profile(css_details, css_profile)

p "getting key stats"
scraper.get_key_stats(xpath_key_stats)

p "outputting csv"
scraper.output_csv
