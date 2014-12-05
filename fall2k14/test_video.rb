require 'csv'

arry = CSV.read("fall2k14.csv", {headers: false})
arry2 = CSV.read("videos.csv", {headers: false})

arry.each do |row|
  arry2.each do |row2|
    row << "#{row2[2]}" if row[0].split(' ').join('').downcase == row2[1].downcase
  end
end

CSV.open('plus_video.csv', 'w') do |csv|
  csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code"]
  arry.each do |row|
    csv << row
  end
end

arry = CSV.read("plus_video.csv", {headers: false})
headers = ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code"]
arry.each do |row|
  p row[0] if row[13].nil?
end
