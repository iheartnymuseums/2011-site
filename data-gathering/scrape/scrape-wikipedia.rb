require 'common'




STORED_PAGES_DIR = "wikipedia-pages"
WIKI_ROOT_URL = 'http://en.wikipedia.org'
URL = "#{WIKI_ROOT_URL}/wiki/List_of_museums_and_cultural_institutions_in_New_York_City"
current_file = nil;
#File.open('wikipedia-list.txt', 'r'){|f| current_file = f.readlines.join }
OUTPUT = File.open("wikipedia-list2.txt", 'w')

def get_html_file(remote_href, opt={})
  opt[:ext] ||= 'html'
  opt[:local_dir] ||= STORED_PAGES_DIR
  opt[:sleep] ||= 2.0 + rand*3
  local_href = "#{STORED_PAGES_DIR}/"+"#{remote_href}".partition(/\/\//).last.gsub(/\//, '_').to_s + ".#{opt[:ext]}"
  html = ''
  if !File.exists?(local_href)
    puts "Downloading:  #{remote_href}"
    if html = Nokogiri::HTML(open(remote_href, "User-Agent"=>HTTP_USER_AGENT))
      File.open(local_href, 'w'){|f| f.write(html.to_html)  }
      puts "\tWrote #{local_href}"
      puts "\t...sleeping for #{opt[:sleep]}"
      sleep opt[:sleep]
    end
  else
    puts "#{local_href} exists"
    html = Nokogiri::HTML(open(local_href))
  end
  puts "\nDocument #{local_href}\t has #{html.to_s.length} chars"
  return html
end

def wiki_parse_infocard(html)
  html = Nokogiri::HTML(html) if html.is_a?String
  trs = nil
  if card = html.css(".infobox.vcard")
    trs = card.css('tr').select{|tr| tr.css('th,td').length > 1}.inject({}){|hash,tr|
      
      key, value = tr.css('th,td')
  #    puts "tr children:\t #{tr.children.length}: #{tr.children.map{|c| c.name}.join("\t")}"
      #puts "\t#{key.text.downcase}:\t#{value.text}"
      puts "#{key.text.downcase.instrip}"
      hash[key.text.downcase.instrip] = value.andand.text.instrip
      hash
    }
    
    
    aimages = card.css('a.image')
    if aimg = aimages.first
      trs['lede_image_page_url'] = "#{WIKI_ROOT_URL}#{aimg['href']}"
      trs['lede_image'] = "#{aimg.css('img')[0].andand['src']}"
      trs['lede_image'] = "#{WIKI_ROOT_URL}#{trs['lede_image']}" if trs['lede_image'] =~ /^\//
    end
      
  end
  return trs
end

puts "Downloading first page"
homepage = get_html_file(URL)


lis = homepage.xpath("//span[@id='Museums']/following::li") & homepage.xpath("//span[@id='Performing_arts']/preceding::li")

lis.each do |li|
  link = li.css('a')[0]
  if link
    page_name = link.text
    
    href = link['href']
    if link['class'] != 'new'
      puts "Fetching page for #{page_name}"
      remote_href = "#{WIKI_ROOT_URL}#{href}"
      begin
        html = get_html_file(remote_href)
      rescue OpenURI::HTTPError=>e
        puts "\tHTTPError: #{e.message}"
        sleep 0.1
      rescue Timeout::Error=>e
        puts "\tTimeout: #{e.message}"
        sleep 0.1
      rescue StandardError=>e
        puts "\tStandard Error: #{e.message}"
      else
        puts "\tSuccess!\n\nProcessing...#{page_name}:"
        infocard = wiki_parse_infocard(html)
        infocard.merge!('name'=>page_name, 'url'=>href)
        pp infocard
        output_str = WIKI_FIELDS_FORMAT.map{|w| infocard[w]}
        OUTPUT.puts(output_str.join("\t"))
      end
          
    end
  else # no link
    puts "A li with no link: #{li.text}"  
  end  
end