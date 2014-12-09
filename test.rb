require 'nokogiri'
require 'open-uri'

url = 'http://finovate.com/europe13vid/bbva.html'
doc = Nokogiri::HTML(open("#{url}"))

p doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > table > tr > td.cellpadding-left > p:nth-child(7)').inner_html
