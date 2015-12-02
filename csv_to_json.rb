require 'rubygems'
require 'json'
require 'fastercsv'
require 'andand'
require 'active_support/core_ext/integer/inflections'
require 'pp'
ICONS =   %w[homepage wikipedia yelp facebook twitter youtube flickr]
DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

class String
  def to_12(opt={})
    if x = self.match(/(\d{2})(\d{2})/)
      "#{x[1].to_i%12==0 ? 12 : x[1].to_i%12}#{":#{x[2]}" unless x[2].to_i==0}#{x[1].to_i<12 || x[1].to_i==24 ? 'AM' : 'PM'}"
    else
      x
    end
  end
end

line_num = 0
arr_entries = []
lines = []
headers = nil


FasterCSV.foreach("museums.csv") do |row|
  
  lines << row
  if line_num ==0
    headers = row
  else
    o = row.each_with_index.inject({}){|hash, (val, idx)|
      hash[headers[idx]] = row[idx]
      hash  
    }
    arr_entries << o
  end
  line_num +=1
  
end

File.open("museums.js", 'w'){|f| f.write(arr_entries.to_json)}
File.open("museums.txt", 'w'){|f| lines.map{|line| f.puts(line.join("\t"))}}

html = ''


# sort arr_entries by popularity
arr_entries.sort!{|y,x| x['review_count'].to_i <=> y['review_count'].to_i}

header_str = <<HERE
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US"> 
<head profile="http://gmpg.org/xfn/11"> 
<title>I Heart Museums and Culture in New York City</title> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<meta name="description" content="A guide and interactive map of New York's museums and culture, free and not" /> 
<link href="css/style.css" rel="stylesheet" type="text/css" media="screen" /> 
<link href="css/tablesorter.css" rel="stylesheet" type="text/css" media="screen" /> 
<script type="text/javascript" src="https://www.google.com/jsapi?key=ABQIAAAA5-UGHE4EbkM8KYpCxlHY9RR5y0BS05_sYPc4sd1FC97fQapiuBSmUDIMsz1iVXmsaklEJ-N8755__g"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
<!-- <script type="text/javascript" src="js/jquery-1.5.min.js"></script> -->
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/jquery.scrollTo.min.js"></script>
<script type="text/javascript" src="js/application.js"></script>
<script type="text/javascript" src="js/map.js"></script>

<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>

<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-21605935-1']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>


</head>
<body>
<div id="container">
  <div id="header">
  
    <h1 id="site-hed"><a href="index.html">I <span class="heart">&hearts;</span> NY's Museums</a></h1>
    <ul class="navbar">
    <li><a href="index.html">The List</a></li>
    
      <li><a href="about.html">About</a></li>
 	      <li><a href="http://tumblr.eyeheartnewyork.com">Tumblr</a></li>     
 	 	  <li><a href="http://danwin.com">Danwin.com</a></li>
 	 	  <li><a href="http://http://www.flickr.com/photos/zokuga/"><img class="icon" src="icons/flickr_btn.png" /></a></li>
 	 	  <li><a href="http://www.twitter.com/dancow"><img class="icon" src="icons/twitter_btn.png" /></a></li>

      
    </ul>
  </div>
  <div id="content">
  
 
HERE


table_str = <<TABLE 
    <div class="section clearfix" id="top-wrapper">
      <div class="left col">
      <h2>The NY List: Museums, Zoos, and other Culture</h2>
          <p>
    There are so many places to visit in New York that it's easy to forget some of the less-famous sites, nevermind search out their websites to find their hours and pricing. And sometimes, free hours are all we can afford. So I put together a list of what I could find.
                </p>
    <p>
  	Colored bars indicate the operating hours. <span style="color:blue">Blue</span> are the free/suggested donation times. Click on the headers to sort the columns. The "<a href="http://www.yelp.com/manhattan" title="Manhattan Restaurants, Dentists, Bars, Beauty Salons, Doctors">Yelp</a>" column draws in the <a href="http://www.yelp.com/manhattan" title="Manhattan Restaurants, Dentists, Bars, Beauty Salons, Doctors">number of reviews and average rating</a>, as one measure of popularity. The <strong>"Fee"</strong> column shows the standard adult ticket and membership price.
    </p>  
<p>The map has a simlar color scheme as the list, with bigger icons for more popular places</p>
      <p class="imp">
   Museums with <span class="suggested">suggested donations have <strong>darker blue bars</strong></span>, and a <span class="suggested">*</span> by their fee. 
      </p>
        
  <p> 
        <em>  
         Read <a href="/about.html">more about this list</a>, contact me at <a href="mailto:dan@danwin.com">dan@danwin.com</a> or follow me <a href="http://twitter.com/dancow">@dancow</a> on Twitter.
         </em>         
         
         
         </p>
         
         <strong style="font-size: 9pt; font-family: Arial;">Share:</strong>
         <ul class="share">
             <li><a href="http://www.flickr.com/zokuga/photos"><img class="icon" src="icons/flickr_btn.png" /></a></li>
        	 	  <li><a href="http://www.twitter.com/dancow"><img class="icon" src="icons/twitter_btn.png" /></a></li>
        	 	</ul>   
       
       
        
      </div><!--end of left col -->
      <div class="right col">
        <div id="map-wrap">This Google Map requires Javascript</div>
      </div><!--end of right col -->
    </div>
    
  <div class="section" id="listing-wrapper">
  <table id=\"listing\" class="tablesorter">
  <thead>
    <tr>
      <th>Name</th>
      <th>Address</th>
      <th>Fee $</th>
      <th>Yelp Info</th>
      <th class='day'>Sun.</th>
      <th class='day'>Mon.</th>
      <th class='day'>Tues.</th>
      <th class='day'>Wed.</th>
      <th class='day'>Thurs.</th>
      <th class='day'>Fri.</th>
      <th class='day'>Sat.</th>      
    </tr>
  </thead>  
  <tbody>
TABLE

html << header_str
html << table_str



arr_entries.each_with_index do |entry, entry_idx|

icons = ICONS.map{|icon| "<a href=\"#{entry["#{icon}_url"]}\"><img class=\"icon\" src=\"icons/#{icon}_btn.png\"></a>" if entry["#{icon}_url"]}.compact
is_free = (entry['fee'].to_i == 0 && !entry['fee'].blank?) 
has_suggested_fee = entry['suggested'] == 'TRUE'
free_days = entry['free'].to_s.split(/\|/).inject([]){ |f_arr, f_s| 
  #f_s = f_sa[1]
  puts "#{entry['name']} #{f_s.to_s}"
  
  if fd = f_s.match(/(\d):(\d{4})-(\d{4});?([\d,]*)\*?(.*)/)
  #;?([\d,]*)\*?(.*)
  
    left = 100*fd[2].to_f/2400.0
    width = 100*fd[3].to_f/2400.0 - left
    ordinals = "#{fd[4].split(',').map{|o| o.to_i.ordinalize}.join(', ')} of month"  unless fd[4].blank?
  
    f_arr[fd[1].to_i] = [left,width, "#{fd[2]}-#{fd[3]}", ordinals, fd[5] ]
  end
  f_arr
}

pp free_days

days = DAYS.each_with_index.map{|dayname, idx|
  
  is_closed = entry[dayname].blank?
  has_free_hours_today = !free_days[idx].blank? || is_free
  
  td_str = "<td class=\"day #{'closed' if is_closed} #{'free' if has_free_hours_today}\" data-sk=\"#{'X' if is_closed}#{has_free_hours_today ? 'F' : 'N'}#{entry[dayname]}\">"
  unless entry[dayname].to_s.blank?
    day = entry[dayname].to_s
    
    # calculate css width, left of part-bar
    hours = day.match(/(\d{4})-(\d{4})/)[1..2]
    hours[0] = 100 * hours[0].to_i / 2400.0
    hours[1] = 100*hours[1].to_i/2400.0 - hours[0]
    
    # if free day, create div.part-free
    free_div = "<div class=\"part-bar free\" style=\"position:absolute; top: 0; left:#{(free_days[idx][0]).to_i}%; width:#{(free_days[idx][1]).to_i}%\"></div>" unless free_days[idx].blank?
    
    str = <<HERE
    <div class="day-bar">
      <div class="part-bar #{is_free ? 'free' : 'open'}" style="left:#{(hours[0]).to_i}%; width:#{(hours[1]).to_i}%"></div>
      #{free_div}
    </div>
    <div class="sked dt">
    #{day.split('-').map{|d| d.to_12}.join('-')}
    
    
    #{"#{"<div class=\"free\">#{free_days[idx][2].split('-').map{|d| d.to_12}.join('-')}</div>"}
    #{"#{"<div class=\"ordinals\">#{free_days[idx][3]}</div>" if free_days[idx][3]}"}" unless free_days[idx].blank?} 
    
    
    


    </div>
HERE
    td_str << str
  else
    td_str << "<div class=\"day-bar\"></div>"
  end
  td_str << "</td>"
  
  
  td_str
}
#############
############# =>  end of days.map

str = <<HERE
<tr 
class="#{'suggested' if has_suggested_fee}" 
data-name="#{entry['name']}" data-popsize="#{((arr_entries.length-entry_idx).to_f/arr_entries.length * 4.0).ceil}" data-idnum="#{entry_idx}" data-lng="#{entry['lng']}" data-lat="#{entry['lat']}">
  <td class="museum_name"><a class="anchor" href="#{entry['homepage_url']}">#{entry['name']}</a>
    <div class="widget-icons">
      #{icons}      
    </div>  
  </td>
  <td class="address">
    <div class="boro">#{entry['city']}</div>
    <div class="street dt">#{entry['street']}</div>
  </td>
  <td class="fee dt">
    <div class="fee">#{'*' if has_suggested_fee}#{"$#{entry['fee'].to_i}"}</div>
    <div class="member fee">#{"$#{entry['membership']}" unless entry['membership'].to_i==0}</div>
  </td>
  <td data-sk="#{entry['review_count']}"  class="yelp_info">
  
    <div class="review_count dt"><a href="http://yelp.com#{entry['yelp_url']}">#{entry['review_count']}</a></div>
    <div class="rating">
      #{entry['rating'].to_i.times.map{|i| '*'}}#{'+' if entry['rating'] =~ /\.5/}
    </div>
  </td>
  
  #{days.map{|day| day}}
  
</tr>
HERE

  html << str
  
end


html << "</tbody></table>\n</div><!--end of listing-wrapper-->"

footer_str = <<HERE
  </div> <!-- end of content -->
  

  <div id="footer">

     <ul class="navbar">
     <li><a href="index.html">The List</a></li>
     
       <li><a href="about.html">About</a></li>
  	      <li><a href="http://tumblr.eyeheartnewyork.com">Tumblr</a></li>     
  	 	  <li><a href="http://danwin.com">Danwin.com</a></li>
  	 	  <li><a href="http://www.flickr.com/zokuga/photos"><img class="icon" src="icons/flickr_btn.png" /></a></li>
  	 	  <li><a href="http://www.twitter.com/dancow"><img class="icon" src="icons/twitter_btn.png" /></a></li>


     </ul>
   </div>  
</div> <!-- end of container -->


</body>
</html>
HERE

html << footer_str


File.open("index.html", 'w'){|f| f.write(html.gsub(/ +/, ' '))}


about_html = ''
body_str = <<ABOUT 

<div class="clearfix" id="about-text">
<h2>About this List</h2>
<div style="float:left; width: 550px;">
<p>Someone on <a href="http://www.reddit.com/r/nyc/comments/fk7fg/you_know_what_i_think_would_be_useful_something/">Reddit wished there was a list of all the times museums were free</a> and so I made one, but included all the non-free places 
because they're usually worth the money. This is so far the places I found off of Wikipedia and Yelp. I've also included a few
galleries, but by no means have made an exhaustive list of those.</p>

<p>See the <a href="index.html">list here</a>. It was tested on <a href="http://www.google.com/chrome/intl/en/landing_chrome_mac.html?hl=en">Google Chrome</a>, 
Safari, and <a href="http://www.firefox.com">Firefox</a>.</p>
<p>This is just a start and since I put together most of it by hand, I'm sure there are a few mistakes or typos. Let me know what you think at <a href="mailto:dan@danwin.com">dan@danwin.com</a> or leave a comment on my <a href="http://danwin.com">blog</a>.
<br> Dan Nguyen - <em>Feb. 23, 2011</em>
</div>
<div style="float: right">
<a href="http://www.flickr.com/photos/zokuga/4471239983/" title="MOMA: White on white by Dan Nguyen @ New York City, on Flickr"><img src="http://farm5.static.flickr.com/4024/4471239983_771b664265.jpg" width="500" height="333" alt="MOMA: White on white" />
<br>
At the MOMA
</a>
</p>
</div>
ABOUT

about_html += header_str + body_str +  footer_str

File.open("about.html", 'w'){|f| f.write(about_html.gsub(/ +/, ' '))}
