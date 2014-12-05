require 'csv'

class Adder

  def initialize(csv)
    @headers = ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Logo","Embed Code","Thumbnail"]
    @csv = csv
  end

  def add_video
    # Add video embed code
    arry = CSV.read("#{@csv}", {headers: false})
    arry2 = CSV.read("videos.csv", {headers: false})

    arry.each do |row|
      arry2.each do |row2|
        row << "#{row2[3]}" if row[0] == row2[1]
      end
    end

    CSV.open('plus_video.csv', 'w') do |csv|
      csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Logo","Embed Code"]
      arry.each do |row|
        csv << row
      end
    end
  end

  def add_thumb
    # Add video thumbnail
    arry = CSV.read("plus_video.csv", {headers: false})
    arry.each do |row|
      arry2.each do |row2|
        row << "#{row2[3]}" if row[13] == row2[2]
      end
    end

    CSV.open('plus_thumbnail.csv', 'w') do |csv|
      csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Logo","Embed Code","Thumbnail"]
      arry.each do |row|
        csv << row
      end
    end
  end

  def add_tax
    # Add taxonomy
    hsh = {
          Regexp.new('[a-dA-D]') => "[A-D]",
          Regexp.new('[e-hE-H]') => "[E-H]",
          Regexp.new('[i-lI-L]') => "[I-L]",
          Regexp.new('[m-pM-P]') => "[M-P]",
          Regexp.new('[q-tQ-T]') => "[Q-T]",
          Regexp.new('[u-zU-Z]') => "[U-Z]"
        }

    arry = CSV.read("plus_thumbnail.csv", {headers: false})

    arry.each do |row|
      letter = row[0].slice(0,1)
      hsh.each do |k, v|
        row << hsh[k] if letter.match(k)
      end
    end

    CSV.open('plus_tax.csv', 'w') do |csv|
      csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Url","Logo","Embed Code","Thumbnail","Tax"]
      arry.each do |row|
        csv << row
      end
    end
  end

  def check_missing
    # Check for missing elements
    arry = CSV.open('plus_tax.csv', 'wr')
    arry.each do |row|
      row.each_with_index do |e,i|
        if e.nil?
          p "#{headers[i]}: #{row[0]}" unless headers[i].match /Key/
        end
      end
    end
  end
end

