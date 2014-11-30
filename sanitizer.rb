require 'csv'

dest = File::open("sanitized_euro2k14.csv", "w")
CSV.foreach("euro2k14_half.csv") do |row|
  next if row[3].empty?
  dest << row.to_csv
end
dest.close
