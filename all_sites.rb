require_relative 'oo_scraper'

scraper = Scraper.new("2013", "FinovateEurope")
scraper.scrape("http://www.finovate.com/europe13vid/", "#contentwrapper > table > tbody > tr > td > table:nth-child(3) > tbody > tr > td > div > table > tbody > tr > td")
scraper.output_csv("europe2k13")
