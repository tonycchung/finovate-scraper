require_relative '../add_vid_thumb_tax.rb'

csv = 'finovate2k7'
adder = Adder.new(csv)

p 'adding video'
adder.add_video

p 'adding thumbs'
adder.add_thumb

p 'adding tax'
adder.add_tax

p 'checking missing'
adder.check_missing("#{csv}_master.csv")
