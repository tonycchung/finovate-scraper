require 'csv'

arry = CSV.read("euro2k14.csv", {headers: false})
arry.each do |row|
  row.each do |string|
    next if string.nil?
    string.rstrip!
    string.lstrip!
  end
end

CSV.open("sanitized_euro2k14.csv", "w") do|csv|
  arry.each do |row|
    csv << row
  end
end
