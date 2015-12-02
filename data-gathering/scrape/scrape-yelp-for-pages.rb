require 'common'
include Muser

YELP_URL = "http://www.yelp.com" #?find_desc=Jamaica+Bay+Wildlife+Refuge&find_loc=nyc"
output_yelp = File.open("yelp-list-new.txt", 'w')
output_yelp.puts(YELP_FIELDS_FORMAT.join("\t"))
places = File.open("yelp-list-cleaned.txt", 'r').readlines[1..-1].map{|t| t.split("\t")}.reject{|t| t[2].blank?}

places.each do |place|
  # do query
  begin
    doc = Muser.get_remote_file("#{YELP_URL}#{place[2]}", :local_dir=>'yelp-pages/')
 
  rescue StandardError=>e
    puts "Standard error: #{e.message}"
  else
    # do a parse
    
    if !doc.respond_to?('code') || doc.code.andand==200
      page = Muser.parse(doc)
      obj = {'wiki_name'=>place[0], 'yelp_name'=>place[1], 'url'=>place[2]}
      if item = page.css('#bizRating').first
        obj['rating'] = item.css('.rating img').first.andand['title'].to_s.match(/^([\d\.]+)/).andand[1]
        obj['reviews'] = item.css('.review-count span.count').andand.text.to_i
      end
      
      if item = page.css('#bizInfoContent address')
          obj['street'] = item.css('.street-address').text.instrip
          obj['city'] = item.css('.locality').text.instrip
          obj['zip'] = item.css('.postal-code').text.instrip
      end
      
      if item = page.css('#bizPhone').first
        obj['phone'] = item.text
      end
      
      if item = page.css('#bizUrl a.url')
        obj['website'] = "http://#{item.text}".instrip unless item.text.blank?
      end
      
      str=YELP_FIELDS_FORMAT.map{|yf| obj[yf].to_s.strip}.join("\t")
      puts str
      output_yelp.puts(str)

      
    end
  end
  
end  