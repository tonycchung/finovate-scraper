require 'csv'

arry = CSV.read("euro2k14.csv", {headers: false})
arry.each do |row|
  row[3] = nil
  row.compact!
end

CSV.open("sanitized_euro2k14.csv", "w") do|csv|
  arry.each do |row|
    csv << row
  end
end
