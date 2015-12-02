require 'common'
include Muser

YELP_URL = "http://www.yelp.com" #?find_desc=Jamaica+Bay+Wildlife+Refuge&find_loc=nyc"
YELP_LOC = 'nyc'
output_yelp = File.open("yelp-list-old.txt", 'w')
output_yelp.puts(YELP_FIELDS_FORMAT.join("\t"))
place_names = File.open("wikipedia-list.txt", 'r').readlines.map{|line| line.split("\t").first}


place_names.each do |place_name|
  # do query
  begin
    doc = Muser.get_remote_file("#{YELP_URL}/search", :local_dir=>'yelp-searches/',:params=>{'find_desc'=>place_name, 'find_loc'=>YELP_LOC})
  rescue RestClient::Error=>e
    puts "RestClient error: #{e.message}" 
  rescue StandardError=>e
    puts "Standard error: #{e.message}"
  else
    # do a parse
    
    if !doc.respond_to?('code') || doc.code.andand==200
      page = Muser.parse(doc)
      obj = {}
      if item = page.css('div.businessresult').first
        title = item.css('#bizTitleLink0')
        obj['name'] = title.text.gsub(/^\d+\./, '').instrip
        obj['url'] = title.css('a').first.andand['href']
        obj['reviews'] = item.css('.reviews').text.to_i
        obj['rating'] = item.css('.rating img').first.andand['title'].to_s.match(/^([\d\.]+)/).andand[1]
        addr = item.css('address').andand.children.andand.reject{|c| c.name =='br' || c.text.blank?}
        obj['street'] = addr.first
        obj['city'], obj['zip'] = addr[1].text.split(/, NY /).map{|a| a.strip}
        obj['phone'] = addr[2].text
        
        str=[place_name, YELP_FIELDS_FORMAT.map{|yf| obj[yf].to_s.strip}].flatten.join("\t")
        puts str
        output_yelp.puts(str)
      end
    end
  end
  
end  