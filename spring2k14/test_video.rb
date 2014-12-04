require 'csv'
require 'amatch'
include Amatch


arry = CSV.read("spring2k14.csv", {headers: false})
arry2 = CSV.read("videos.csv", {headers: false})

arry.each do |row|
  arry2.each do |row2|
    row << "#{row2[2]}" if "#{row[0]}" == "#{row2[2]}"
  end
end

CSV.open('plus_video.csv', 'w') do |csv|
  csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code"]
  arry.each do |row|
    csv << row
  end
end

arry_video = CSV.read("plus_video.csv", {headers: false})
headers = ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code"]
arry_video.each do |row|
  row.each_with_index do |e,i|
    if e.nil?
      p "#{headers[i]}: #{row[0]}" unless headers[i].match /Key/
    end
  end
end
