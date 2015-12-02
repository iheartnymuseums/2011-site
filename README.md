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

I built this [iheartnymuseums.com](http://iheartnymuseums.com) back when the only way I knew how to launch a website was either by running `rails new project` or creating Flash apps. I had not learned about [Jekyll](https://jekyllrb.com/) or [Middleman](https://github.com/middleman/middleman) and probably had barely touched Github.  

It was a hit, particularly among the large demographic of New Yorkers who are both into art and for whom finding free things is necessary for continued survival in the city. I [blogged about my Internet fame at the time](http://danwin.com/2011/02/the-free-list-of-free-new-york-museums-iheartnymuseums-com/):

> Last Wednesday, in my haste to get it over with before I forgot about it after a weekend at NICAR, I threw up a hand-compiled chart of New York museums and other cultural attractions, focused primarily on when they were open and free. [This was in response to a NY reddit user who asked just the right question](http://www.reddit.com/r/nyc/comments/fk7fg/you_know_what_i_think_would_be_useful_something/) to hit my “hey-maybe-*I*-can-do-something” buttons...
> 
> Well, I’m not much of a designer but I like making stuff that uses simple color bars and graphics to represent data, ever since my boss made me attend a Edward Tufte lecture...I got interview requests from writers at the Village Voice and the WSJ the day the map went up, so hopefully this chart gets out to the people who need one more reminder to check out all that’s great in this city.

What a hoser I was. And yet [iheartnymuseums.com](http://iheartnymuseums.com) remains the most important and popular thing I have ever contributed to the Internet. So even though I'm long gone out of New York, I'm hoping to redo it in Middleman and React over the holiday break. Or at least add `<link rel="stylesheet" href="bootstrap.css"> to it.
