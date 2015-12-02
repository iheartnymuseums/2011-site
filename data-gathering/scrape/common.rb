require 'rubygems'
require 'nokogiri'
require 'rest-client'
require 'open-uri'
require 'andand'
require 'pp'
HTTP_USER_AGENT = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.102 Safari/534.13"
WIKI_FIELDS_FORMAT = %w[name url type location website lede_img lede_img_url]
YELP_FIELDS_FORMAT = %w[wiki_name  yelp_name  url reviews rating street city zip phone website]


class String
  def instrip
   self.gsub(/(?:\s|\t|\r| |\n)+/, ' ').strip 
  end
  
end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

module Muser
  def Muser.get_remote_file(remote_href, opt={})
  #  ext = remote_href.match(/\.(\w{1,4})$/).andand[1]
  #  opt[:ext] ||= ext.blank? ? 'html' : ext
    opt[:local_dir] ||= ''
  
    opt[:sleep] ||= 1.0 + rand*3
  
  
    local_href = opt[:local_dir] + "#{remote_href}".partition(/\/\//).last.gsub(/[^\w\d_#&.]/, '_').to_s
    local_href << opt[:params].collect.join('-') if opt[:params]
    if opt[:ext]
      local_href << opt[:ext]
    else
      local_href << '.html' unless remote_href.match(/\.(\w{1,4})$/).andand[1] =~ /(?:jpg|jpeg|gif|png|doc.|pdf|zip|tif.)/
    end
  
    file = nil
    if !File.exists?(local_href) || opt[:overwrite]==true
      puts "Downloading:  #{remote_href} ?: #{opt[:params]}"
      sleep opt[:sleep]
      # Manage a specific error code
      resp = RestClient.get(remote_href, :params=>opt[:params]){ |response, request, result, &block|
         if response.code==200
           p "Success: \tReceived page 200" 
           file = response
           File.open(local_href, 'w'){|f| f.write(file)  } unless opt[:save_file]==false
         elsif [301, 302, 307].include?(response.code)
            response.follow_redirection(request, result, &block)   
         else
           puts "Received code: #{response.code}"
         end
       }
   
    else
      puts "#{local_href} exists"
      file = File.open(local_href, 'r').readlines.join
    end
    puts "Document #{local_href}\t has #{file.to_s.length} chars\n"
    return file
  end

  def Muser.parse(str, type='html')
    case type
    when 'html'
      Nokogiri::HTML(str)
    else
      str
    end
  end  
  
  
end
