require 'csv'

arry = CSV.read('videos.csv', {headers: false})
new_arry = []

arry.each do |row|
  new_arry << row if row[0].match /best/i
end

CSV.open('best_of_videos.csv', 'w') do |csv|
  new_arry.each do |row|
    csv << row
  end
end
