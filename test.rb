require 'nokogiri'
require 'open-uri'

url = 'http://www.finovate.com/fall11vid/demyst.html'
doc = Nokogiri::HTML(open("#{url}"))

p doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > table > tr > td > ul > li > table > tr > td > div > table > tr > td.cellpadding-left').inner_html
