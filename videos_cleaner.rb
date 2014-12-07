require 'csv'

CSV.foreach('videos.csv') do |row|
  row[1] = row[1].match /^.*[^\.mov]/
end
