require 'csv'

headers = ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Logo","Embed Code","Thumbnail"]

hsh = {
        Regexp.new('[a-dA-D]') => "[A-D]",
        Regexp.new('[e-hE-H]') => "[E-H]",
        Regexp.new('[i-lI-L]') => "[I-L]",
        Regexp.new('[m-pM-P]') => "[M-P]",
        Regexp.new('[q-tQ-T]') => "[Q-T]",
        Regexp.new('[u-zU-Z]') => "[U-Z]"
      }

arry = CSV.read("euro2k14_master.csv", {headers: false})

arry.each do |row|
  letter = row[0].slice(0,1)
  hsh.each do |k, v|
    row << hsh[k] if letter.match(k)
  end
end

CSV.open('euro2k14_master_tax.csv', 'w') do |csv|
  arry.each do |row|
    csv << row
  end
end
