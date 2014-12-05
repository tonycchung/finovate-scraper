require 'csv'

arry = CSV.read("test.csv", {headers: false})
arry.each do |row|
  row[4].gsub!('),', ');')
  p row[4]
end
