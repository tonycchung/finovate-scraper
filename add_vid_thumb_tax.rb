require 'csv'
require 'amatch'

class Adder
  include Amatch
  def initialize(csv)
    @headers = ["Video Show",
                "Show year",
                "Location",
                "Key Execs",
                "Key Board Members",
                "Key Advisory Board Members",
                "Key Investors",
                "Key Partnerships",
                "Key Customers",
                "Company Details",
                "Company Profile",
                "Product Distribution Strategy",
                "Contacts",
                "Url",
                "Logo",
                "Logo URL",
                "Embed Code",
                "Thumbnail",
                "Taxonomy"]
    @csv = csv
    @videos_csv = CSV.read("videos.csv", {headers: false})
  end

  def add_video
    # Add video embed code
    arry = CSV.read("#{@csv}.csv", {headers: true})

    arry.each do |row|
      m = Jaro.new(row[0])
      @videos_csv.each do |video_row|
        if video_row[1].match /\.mp4/
          break
        elsif row[0].split(' ').join.downcase == video_row[1].split(' ').join.downcase
          row << "#{video_row[2]}"
          break
        elsif row[0].split(' ').join.downcase == video_row[1].match(/.*[^_QUICKTIME]/).to_s.downcase
          row << "#{video_row[2]}"
          break
        elsif m.match(video_row[1].match(/.*[^_QUICKTIME]/).to_s) > 0.9
          row << "#{video_row[2]}"
          break
        end
      end
    end

    CSV.open("#{@csv}_plus_video.csv", 'w') do |csv|
      csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Product Distribution Strategy","Contacts","Url","Logo","Logo URL","Embed Code"]
      arry.each do |row|
        csv << row
      end
    end
  end

  def add_thumb
    # Add video thumbnail
    arry = CSV.read("#{@csv}_plus_video.csv", {headers: true})
    arry.each do |row|
      @videos_csv.each do |video_row|
        row << "#{video_row[3]}" if row[16] == video_row[2]
      end
    end

    CSV.open("#{@csv}_plus_video_thumb.csv", 'w') do |csv|
      csv << ["Video Show","Show year","Location","Key Execs","Key Board Members","Key Advisory Board Members","Key Investors","Key Partnerships","Key Customers","Company Details","Company Profile","Product Distribution Strategy","Contacts","Url","Logo","Logo URL","Embed Code","Thumbnail"]
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

    arry = CSV.read("#{@csv}_plus_video_thumb.csv", {headers: true})

    arry.each do |row|
      letter = row[0].slice(0,1)
      hsh.each do |k, v|
        row << hsh[k] if letter.match(k)
      end
    end

    CSV.open("#{@csv}_plus_video_thumb_tax.csv", 'w') do |csv|
      csv << @headers
      arry.each do |row|
        csv << row
      end
    end
  end

  def check_missing(csv)
    # Check for missing elements
    count = 0
    arry = CSV.open(csv, 'r')
    arry.each do |row|
      row.each_with_index do |e,i|
        if e.nil? || e == ""
          unless @headers[i].match /Key|Embed|Product/
            p "#{@headers[i]}: #{row[0]}"
            count += 1
          end
        end
      end
    end
    p "Number missing: #{count}"
  end
end

# {location[1]}{showyear[1]}{videoshow[1]}
