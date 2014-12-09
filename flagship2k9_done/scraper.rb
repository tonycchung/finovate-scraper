require_relative '../oo_scraper'

show_name = 'flagship2k9'
year = '2009'
location = 'Manhattan'
main_url = 'http://www.finovate.com/flagship09vid/'
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