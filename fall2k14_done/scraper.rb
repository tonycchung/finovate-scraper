require_relative '../oo_scraper'

show_name = 'fall2k14'
year = '2014'
location = 'fall'
main_url = 'http://www.finovate.com/fall14vid/'
shows_td = '#contentwrapper table tbody tr td table:nth-child(3) tbody tr td div table tbody tr td'

scraper = Scraper.new(show_name, year, location, main_url)

p 'getting shows'
scraper.get_shows(shows_td)

p 'getting company_profile'
scraper.get_company_profile

p 'getting key stats'
scraper.get_key_stats

p 'outputting csv'
scraper.output_csv
