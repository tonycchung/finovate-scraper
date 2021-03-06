require 'wistia'
require 'csv'

Wistia.use_config!(:wistia => {
  :api => {
    :password => ENV['WISTIA_API_PASSWORD'],
    :format => 'json'
  }
})

arry = []
20.times do |x|
  break if Wistia::Media.find(:all, :params => {:page => "#{x+1}"}).elements.empty?
  arry << Wistia::Media.find(:all, :params => {:page => "#{x+1}"})
end

# ActiveResource -> @element -> WistiaMedia -> @attributes -> HashWithIndifferentAccess
CSV.open('videos.csv', 'w') do |csv|
  csv << ['Conference', 'name', 'embed_code', 'featured_image']
  arry.each do |resource|
    resource.elements.each do |media|

      conference = "#{media.attributes[:project].attributes[:name]}"
      name = "#{media.attributes[:name]}"
      embed_code = "//fast.wistia.net/embed/iframe/#{media.attributes[:hashed_id]}"
      thumbnail = "#{media.attributes[:thumbnail].attributes[:url]}".match /^.*(jpg)/.to_s

      csv << [
              conference,
              name,
              embed_code,
              thumbnail
             ]
    end
  end
end

arry = CSV.read('videos.csv', {headers: false})

CSV.open('videos.csv', 'w') do |csv|
  arry.each do |row|
    row[1] = row[1].split('.mov').first
    csv << row
  end
end

=begin
{"id"=>5663753, "name"=>"AMP.mov", "type"=>"Video", "created"=>"2014-01-21T21:02:40+00:00", "updated"=>"2014-01-21T21:20:22+00:00", "duration"=>439.0, "hashed_id"=>"knn27izp7x", "description"=>"", "progress"=>1.0, "status"=>"ready", "thumbnail"=>#<Wistia::Media::Thumbnail:0x007f41c321ef60 @attributes={"url"=>"http://embed.wistia.com/deliveries/45c7835d8c163958edd0e7c4befa6b65c4fdd54d.jpg?image_crop_resized=100x60", "width"=>100, "height"=>60}, @prefix_options={}, @persisted=true>, "project"=>#<Wistia::Project:0x007f41c321d6b0 @attributes={"id"=>598281, "name"=>"Asia2013", "hashed_id"=>"mk8vo5bfps"}, @prefix_options={}, @persisted=true>, "assets"=>[#<Wistia::Media::Asset:0x007f41c324e030 @attributes={"url"=>"http://embed.wistia.com/deliveries/e04b6121bc4213350aec6af3a2be708bb2238911.bin", "width"=>960, "height"=>540, "fileSize"=>72450472, "contentType"=>"video/mp4", "type"=>"OriginalFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c324d3d8 @attributes={"url"=>"http://embed.wistia.com/deliveries/e3e131d1685ea03b1ce9a49849755c9a6e14e7bc.bin", "width"=>640, "height"=>360, "fileSize"=>44174265, "contentType"=>"video/x-flv", "type"=>"FlashVideoFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c324c7d0 @attributes={"url"=>"http://embed.wistia.com/deliveries/6f620af45d705e18e7cf9b829469f43422323b69.bin", "width"=>960, "height"=>540, "fileSize"=>71614545, "contentType"=>"video/x-flv", "type"=>"MdFlashVideoFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c3253008 @attributes={"url"=>"http://embed.wistia.com/deliveries/3daf5e761356e611a3fa9e9f8bc94eed8657db70.bin", "width"=>960, "height"=>540, "fileSize"=>71487794, "contentType"=>"video/mp4", "type"=>"MdMp4VideoFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c3251438 @attributes={"url"=>"http://embed.wistia.com/deliveries/551e93cd3b2d772aee61735a863b2ec47f61673c.bin", "width"=>640, "height"=>360, "fileSize"=>50145970, "contentType"=>"video/mp4", "type"=>"IphoneVideoFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c325f9c0 @attributes={"url"=>"http://embed.wistia.com/deliveries/45c7835d8c163958edd0e7c4befa6b65c4fdd54d.bin", "width"=>960, "height"=>540, "fileSize"=>47768, "contentType"=>"image/jpeg", "type"=>"StillImageFile"}, @prefix_options={}, @persisted=true>], "embedCode"=>"<object id=\"wistia_5663753\" classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\"960\" height=\"540\"><param name=\"allowfullscreen\" value=\"true\" /><param name=\"allowscriptaccess\" value=\"always\" /><param name=\"wmode\" value=\"opaque\" /><param name=\"flashvars\" value=\"videoUrl=http://embed.wistia.com/deliveries/6f620af45d705e18e7cf9b829469f43422323b69.bin&stillUrl=http://embed.wistia.com/deliveries/45c7835d8c163958edd0e7c4befa6b65c4fdd54d.bin&playButtonVisible=true&controlsVisibleOnLoad=false&unbufferedSeek=false&autoLoad=false&autoPlay=false&endVideoBehavior=default&embedServiceURL=http://distillery.wistia.com/x&accountKey=wistia-production_121563&mediaID=wistia-production_5663753&mediaDuration=439.0\" /><param name=\"movie\" value=\"http://embed.wistia.com/flash/embed_player_v2.0.swf\" /><embed src=\"http://embed.wistia.com/flash/embed_player_v2.0.swf\" name=\"wistia_5663753\" type=\"application/x-shockwave-flash\" width=\"960\" height=\"540\" allowfullscreen=\"true\" allowscriptaccess=\"always\" wmode=\"opaque\" flashvars=\"videoUrl=http://embed.wistia.com/deliveries/6f620af45d705e18e7cf9b829469f43422323b69.bin&stillUrl=http://embed.wistia.com/deliveries/45c7835d8c163958edd0e7c4befa6b65c4fdd54d.bin&playButtonVisible=true&controlsVisibleOnLoad=false&unbufferedSeek=false&autoLoad=false&autoPlay=false&endVideoBehavior=default&embedServiceURL=http://distillery.wistia.com/x&accountKey=wistia-production_121563&mediaID=wistia-production_5663753&mediaDuration=439.0\"></embed></object><script src=\"http://embed.wistia.com/embeds/v.js\"></script><script>if(!navigator.mimeTypes['application/x-shockwave-flash'] || navigator.userAgent.match(/Android/i)!==null)Wistia.VideoEmbed('wistia_5663753','960','540',{videoUrl:'http://embed.wistia.com/deliveries/551e93cd3b2d772aee61735a863b2ec47f61673c.bin',stillUrl:'http://embed.wistia.com/deliveries/45c7835d8c163958edd0e7c4befa6b65c4fdd54d.bin',distilleryUrl:'http://distillery.wistia.com/x',accountKey:'wistia-production_121563',mediaId:'wistia-production_5663753',mediaDuration:439.0})</script>"}
{"id"=>5664021, "name"=>"AppAnnie.mov", "type"=>"Video", "created"=>"2014-01-21T21:22:11+00:00", "updated"=>"2014-01-21T21:29:46+00:00", "duration"=>459.0, "hashed_id"=>"qtc69ot7o2", "description"=>"", "progress"=>1.0, "status"=>"ready", "thumbnail"=>#<Wistia::Media::Thumbnail:0x007f41c325d9b8 @attributes={"url"=>"http://embed.wistia.com/deliveries/384bfeafcbb122c155bb8f857237f80c73668bbc.jpg?image_crop_resized=100x60", "width"=>100, "height"=>60}, @prefix_options={}, @persisted=true>, "project"=>#<Wistia::Project:0x007f41c325ce28 @attributes={"id"=>598281, "name"=>"Asia2013", "hashed_id"=>"mk8vo5bfps"}, @prefix_options={}, @persisted=true>, "assets"=>[#<Wistia::Media::Asset:0x007f41c326fe10 @attributes={"url"=>"http://embed.wistia.com/deliveries/3cf3593491be615c24190fa576ba203115dff570.bin", "width"=>960, "height"=>540, "fileSize"=>73839222, "contentType"=>"video/mp4", "type"=>"OriginalFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c326ef60 @attributes={"url"=>"http://embed.wistia.com/deliveries/865422e95144c9af902c33ea78dd44b49f5ade25.bin", "width"=>640, "height"=>360, "fileSize"=>46628058, "contentType"=>"video/x-flv", "type"=>"FlashVideoFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c326e218 @attributes={"url"=>"http://embed.wistia.com/deliveries/06238401cc1e7a5e96d2958fb17ce044b68d67bd.bin", "width"=>960, "height"=>540, "fileSize"=>75485697, "contentType"=>"video/x-flv", "type"=>"MdFlashVideoFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c326cff8 @attributes={"url"=>"http://embed.wistia.com/deliveries/96e4acd4f944e232fed4792a2b1418443d31aff3.bin", "width"=>960, "height"=>540, "fileSize"=>75108993, "contentType"=>"video/mp4", "type"=>"MdMp4VideoFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c326c198 @attributes={"url"=>"http://embed.wistia.com/deliveries/d28982b43726ef3f8b04bcb75b9e549e2f4b9057.bin", "width"=>640, "height"=>360, "fileSize"=>51362276, "contentType"=>"video/mp4", "type"=>"IphoneVideoFile"}, @prefix_options={}, @persisted=true>, #<Wistia::Media::Asset:0x007f41c3282178 @attributes={"url"=>"http://embed.wistia.com/deliveries/384bfeafcbb122c155bb8f857237f80c73668bbc.bin", "width"=>960, "height"=>540, "fileSize"=>50619, "contentType"=>"image/jpeg", "type"=>"StillImageFile"}, @prefix_options={}, @persisted=true>], "embedCode"=>"<object id=\"wistia_5664021\" classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=\"960\" height=\"540\"><param name=\"allowfullscreen\" value=\"true\" /><param name=\"allowscriptaccess\" value=\"always\" /><param name=\"wmode\" value=\"opaque\" /><param name=\"flashvars\" value=\"videoUrl=http://embed.wistia.com/deliveries/06238401cc1e7a5e96d2958fb17ce044b68d67bd.bin&stillUrl=http://embed.wistia.com/deliveries/384bfeafcbb122c155bb8f857237f80c73668bbc.bin&playButtonVisible=true&controlsVisibleOnLoad=false&unbufferedSeek=false&autoLoad=false&autoPlay=false&endVideoBehavior=default&embedServiceURL=http://distillery.wistia.com/x&accountKey=wistia-production_121563&mediaID=wistia-production_5664021&mediaDuration=459.0\" /><param name=\"movie\" value=\"http://embed.wistia.com/flash/embed_player_v2.0.swf\" /><embed src=\"http://embed.wistia.com/flash/embed_player_v2.0.swf\" name=\"wistia_5664021\" type=\"application/x-shockwave-flash\" width=\"960\" height=\"540\" allowfullscreen=\"true\" allowscriptaccess=\"always\" wmode=\"opaque\" flashvars=\"videoUrl=http://embed.wistia.com/deliveries/06238401cc1e7a5e96d2958fb17ce044b68d67bd.bin&stillUrl=http://embed.wistia.com/deliveries/384bfeafcbb122c155bb8f857237f80c73668bbc.bin&playButtonVisible=true&controlsVisibleOnLoad=false&unbufferedSeek=false&autoLoad=false&autoPlay=false&endVideoBehavior=default&embedServiceURL=http://distillery.wistia.com/x&accountKey=wistia-production_121563&mediaID=wistia-production_5664021&mediaDuration=459.0\"></embed></object><script src=\"http://embed.wistia.com/embeds/v.js\"></script><script>if(!navigator.mimeTypes['application/x-shockwave-flash'] || navigator.userAgent.match(/Android/i)!==null)Wistia.VideoEmbed('wistia_5664021','960','540',{videoUrl:'http://embed.wistia.com/deliveries/d28982b43726ef3f8b04bcb75b9e549e2f4b9057.bin',stillUrl:'http://embed.wistia.com/deliveries/384bfeafcbb122c155bb8f857237f80c73668bbc.bin',distilleryUrl:'http://distillery.wistia.com/x',accountKey:'wistia-production_121563',mediaId:'wistia-production_5664021',mediaDuration:459.0})</script>"}
=end

