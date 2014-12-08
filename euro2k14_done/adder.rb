require_relative '../add_vid_thumb_tax.rb'

adder = Adder.new('euro2k14')

# p 'adding video'
# adder.add_video

# p 'adding thumbs'
# adder.add_thumb

# p 'adding tax'
# adder.add_tax

# p 'checking missing'
# adder.check_missing('euro2k14_plus_video_thumb_tax.csv')

p 'checking missing'
adder.check_missing('euro2k14_master.csv')
