require_relative '../oo_scraper'

show_name = 'startup2k8'
year = '2008'
location = 'startup2k8'
main_url = 'http://www.finovate.com/startup08vid/'
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
