require 'csv'

arry = CSV.read("euro2k14_master.csv", {headers: false})
arry2 = CSV.read("videos.csv", {headers: false})

arry.each do |row|
  arry2.each do |row2|
    row << "#{row2[2]}" if row[0] == row2[1]
  end
end

CSV.open('plus_video.csv', 'w') do |csv|
  csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code"]
  arry.each do |row|
    csv << row
  end
end

headers = ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code"]
arry.each do |row|
  row.each_with_index do |e,i|
    if e.nil?
      p "#{headers[i]}: #{row[0]}" unless headers[i].match /Key/
    end
  end
end
