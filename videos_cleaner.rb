require 'csv'

arry = CSV.read('videos.csv')
new_arry = []

arry.each do |row|
  new_arry << row if row.match /best/i
end

CSV.open('best_of_videos.csv', 'w').each do |csv|
  new_arry.each do |row|
    csv << row
  end
end
