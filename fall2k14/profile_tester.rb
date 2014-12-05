require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open("http://www.finovate.com/fall14vid/tivitzcollegesavings.html"))
company_details = doc.css('#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > table > tr > td:nth-child(2) > p').inner_html

# Save entire company profile from td, add it line by line to company_profile until we've captured only necessary profile data
# (nothing from and after "Product distribution strategy:")
company_profile = ""
profile_css = '#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > table > tr > td.cellpadding-left'
profile_css = '#contentwrapper > table > tr > td > table:nth-child(3) > tr > td > div > div > table > tr > td.cellpadding-left' if doc.css(profile_css).inner_html.empty?
profile = doc.css(profile_css).inner_html

profile.split("\n").each do |line|
  next if line.match(/presenter\s+profile/i)
  break if line.match(/product\s+distribution\s+strategy/i) || line.match(/Key/)
  company_profile << line
end

p company_profile
