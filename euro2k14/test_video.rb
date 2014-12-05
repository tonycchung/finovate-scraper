require 'csv'

# arry = CSV.read("euro2k14_master.csv", {headers: false})
# arry2 = CSV.read("videos.csv", {headers: false})

# arry.each do |row|
#   arry2.each do |row2|
#     row << "#{row2[3]}" if row[0] == row2[1]
#   end
# end

# CSV.open('plus_video.csv', 'w') do |csv|
#   csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code"]
#   arry.each do |row|
#     csv << row
#   end
# end

# headers = ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code"]
# arry.each do |row|
#   row.each_with_index do |e,i|
#     if e.nil?
#       p "#{headers[i]}: #{row[0]}" unless headers[i].match /Key/
#     end
#   end
# end

# arry.each do |row|
#   arry2.each do |row2|
#     row << "#{row2[3]}" if row[13] == row2[2]
#   end
# end

# CSV.open('plus_thumbnail.csv', 'w') do |csv|
#   csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Image","Embed Code", "thumbnail"]
#   arry.each do |row|
#     csv << row
#   end
# end

hsh = {
        Regexp.new('[A-D]') => "[A-D]",
        Regexp.new('[E-H]') => "[E-H]",
        Regexp.new('[I-L]') => "[I-L]",
        Regexp.new('[M-P]') => "[M-P]",
        Regexp.new('[Q-T]') => "[Q-T]",
        Regexp.new('[U-Z]') => "[U-Z]"
      }

arry = CSV.read("euro2k14_master.csv", {headers: false})

arry.each do |row|
  taxonomy = row[0].slice(0,1)
  hsh.each do |k, v|
    row << hsh[taxonomy] if taxonomy.match /"#{k}"/i
  end
end

CSV.open('euro2k14_master_tax.csv', 'w') do |csv|
  arry.each do |row|
    csv << row
  end
end
