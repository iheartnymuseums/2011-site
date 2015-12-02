# iheartnymuseums.com (2011 version)

<a href="http://2011.iheartnymuseums.com"><img src="http://danwin.com/words/wp-content/uploads/2011/02/iheartmuseumsscreengrab.png" alt="screenshot"></a>

[http://2011.iheartnymuseums.com](http://2011.iheartnymuseums.com)

I'm preserving this codebase as a reminder of how terrible of a programmer I was even just a few years back. Somehow I managed to [build news projects for ProPublica using Ruby on Rails](http://www.propublica.org/site/author/dan_nguyen), while yet churning out some seriously WTF code such as this:

~~~ruby
class String
  def to_12(opt={})
    if x = self.match(/(\d{2})(\d{2})/)
      "#{x[1].to_i%12==0 ? 12 : x[1].to_i%12}#{":#{x[2]}" unless x[2].to_i==0}#{x[1].to_i<12 || x[1].to_i==24 ? 'AM' : 'PM'}"
    else
      x
    end
  end
end
~~~


I built this [iheartnymuseums.com](http://iheartnymuseums.com) back when the only way I knew how to launch a website was either by running `rails new project` or creating Flash apps. I had not learned about [Jekyll](https://jekyllrb.com/) or [Middleman](https://github.com/middleman/middleman) or [Sublime Text](http://www.sublimetext.com/) and had probably barely touched Github -- I hadn't even been using *any* version control for my first year or so at ProPublica [until one of the interns patiently suggested that I should](https://source.opennews.org/en-US/articles/boyer-interview/).

You can see the bunch of unorganized scraping scripts in the [data-gathering folder](data-gathering/), just in case you were wondering what amazing programmer skill was needed to create [Dollars for Docs](https://projects.propublica.org/docdollars/). Basically, my saving grace was realizing that I could use a spreadsheet as my content-management system -- in this case, the file [museums.csv](/data-gathering/parse/museums.csv), which was then turned into a webpage via the [csv_to_json.rb](csv_to_json.rb) script. I also didn't know how to actually use the command-line at this point my career so I'm pretty sure the deployment process was opening `irb`, pasting the contents of `csv_to_json.rb` into it, and then manually dragging the finished HTML files into the [Transmit FTP client](https://panic.com/transmit/).

[iheartnymuseums.com] was a hit, particularly among the large demographic of New Yorkers who are both into art and for whom finding free things is necessary for continued survival in the city. I [blogged about my Internet fame at the time](http://danwin.com/2011/02/the-free-list-of-free-new-york-museums-iheartnymuseums-com/):

> Last Wednesday, in my haste to get it over with before I forgot about it after a weekend at NICAR, I threw up a hand-compiled chart of New York museums and other cultural attractions, focused primarily on when they were open and free. [This was in response to a NY reddit user who asked just the right question](http://www.reddit.com/r/nyc/comments/fk7fg/you_know_what_i_think_would_be_useful_something/) to hit my “hey-maybe-*I*-can-do-something” buttons...
> 
> Well, I’m not much of a designer but I like making stuff that uses simple color bars and graphics to represent data, ever since my boss made me attend a Edward Tufte lecture...I got interview requests from writers at the Village Voice and the WSJ the day the map went up, so hopefully this chart gets out to the people who need one more reminder to check out all that’s great in this city.

What a hoser I was. And yet [iheartnymuseums.com](http://iheartnymuseums.com) remains the most important and popular thing I have ever contributed to the Internet. So even though I'm long gone out of New York, I'm hoping to redo it in Middleman and React over the holiday break. Or at least add `<link rel="stylesheet" href="bootstrap.css">` to it.
