require_relative '../add_vid_thumb_tax.rb'

adder = Adder.new('spring2k14_master.csv')

p 'adding thumbs'
adder.add_thumb

p 'adding tax'
adder.add_tax

p 'checking missing'
adder.check_missing
