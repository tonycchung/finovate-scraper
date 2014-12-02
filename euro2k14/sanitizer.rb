require 'csv'

arry = CSV.read("euro2k14.csv", {headers: false})
arry.sort_by! {|e| e[0].split(' ')[0]}

CSV.open("alphabetized_euro2k14.csv", "w") do|csv|
  arry.each do |row|
    csv << row
  end
end
