require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open("http://www.finovate.com/asia13vid/appannie.html"))
company_details = doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > table > tr > td:nth-child(2)').inner_html

# Save entire company profile from td, add it line by line to company_profile until we've captured only necessary profile data
# (nothing from and after "Product distribution strategy:")
company_profile = ""
p doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > div > table > tr > td.cellpadding-left')
