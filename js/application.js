var ICONS = {
	standard:'icons/gmap/default.png',
	closed:'icons/gmap/closed.png',
	free:'icons/gmap/free.png',
	open:'icons/gmap/open.png'
};

var COLUMN_INDEX_POP =3;
var DEFAULT_ICON = ICONS.standard;
var MAP_DIV = "map-wrap";

var g_place_rows;

jQuery(document).ready(function(){
	
	var today_date = new Date(); 
	var today_day = today_date.getDay();
	var today_day_name = $("#listing th.day").map(function(){return $(this).text()}).get()[today_day]
	var today_header_index = $("#listing th").index($("#listing thead th.day").eq(today_day));
	
	
	g_place_rows = $("#listing tbody tr")
	var g_markers = []
	
	g_place_rows.each(function(){
		var place_row = $(this);
		var anchor = place_row.find('td.museum_name a.anchor');
		var td_addr = place_row.children('td.address');
		var home_href = anchor.attr("href");
			anchor.removeAttr('href');
			
		anchor.after("<a class=\"homepage_link\" href=\""+home_href+"\"> (homepage)</a>");	
		
		
			
		var foo_add_click = function(){
			foo_select_place_row(place_row);
			var gmark = gmapper.get_marker_by_id(place_row.data('idnum'));
			gmapper.focus_on_marker(gmark);
			gmapper.open_info_window(gmark);	
		}
		
		anchor.click(function(){foo_add_click()})
		
		td_addr.click(function(){foo_add_click()})
		
		anchor.hover(function(){
			$(this).parent().parent().addClass("highlighted")
		}, function(){
			$(this).parent().parent().removeClass("highlighted")
			
		});
		
		td_addr.hover(function(){ $(this).parent().addClass("highlighted")}, function(){$(this).parent().removeClass("highlighted")})
		
//		place_row.data('title') = place_row.children()
		
		var today_td = place_row.children('td.day').eq(today_day);
		today_td.addClass('today')
		
			var p_info = '';
					
			var today_hours = today_td.hasClass('closed') ? 'Closed' : today_td.children('div.sked').text().trim();
			p_info += today_day_name + ": " + today_hours + "<div>"+place_row.find('td:first-child .widget-icons').html()+"</div>";	
			
	
			place_row.data('info', p_info);
	
		// add icon
			var g_icon;
			if( today_td.hasClass('closed')){
				g_icon = ICONS.closed;
			}else if(today_td.hasClass('free')){
				g_icon = ICONS.free;
			}else{
				g_icon = ICONS.open;
			}
			
				
		var icon_scale = parseInt(place_row.data('popsize'))
		g_markers.push({
			lng:place_row.data('lng'),
			lat:place_row.data('lat'),
			title:place_row.data('name'),
			info:place_row.data('info'),
			id:place_row.data('idnum'),
		//	icon:g_icon,
			icon: new google.maps.MarkerImage(g_icon, null, null, null, new google.maps.Size(4+6*icon_scale,12+7*icon_scale)),
			foo_click: function(){ 
				foo_select_place_row(place_row)
				
			}
			
			
		});
		
		
	})
	
	

	
	
	$("table.tablesorter").tablesorter({
		
		sortList: [ [COLUMN_INDEX_POP,1]], 
        
		textExtraction: function(node) { 
	      var o = ( node.getAttribute("data-sk")!=undefined) ? node.getAttribute("data-sk") : $(node).text();
	      return o;
	    }
	});

	$("table.tablesorter thead th").hover(function(){
	    $(this).addClass("th_hover");
	  }, function(){
	    $(this).removeClass("th_hover");
	  });
		
		
		
	// Mapping stuff
	
	var gmapper = new Gmapper(MAP_DIV, {default_icon:DEFAULT_ICON});  //google.maps.Map(document.getElementById(MAP_DIV),myOptions);
	gmapper.add_markers(g_markers)
	
	gmapper.draw_markers();
	gmapper.resize_map_to_bounds({});
	
		
});


function foo_select_place_row(idnum){
	if(is_empty(idnum.data) && parseInt(idnum) > 0){
		var row = g_place_rows.filter('[idnum='+idnum+']');
	}else{
		var row = idnum;
		idnum = row.data('idnum')
	}
	//console.log("Clicked: a " + idnum);
	foo_select_and_move_row(row);
}

function foo_select_and_move_row(row){
	
	if(!row.hasClass('selected')){
		g_place_rows.removeClass('selected')
		g_place_rows.removeClass('highlighted')
		
		var parent = row.parent();
		row.detach();
		
		
		if(jQuery(document).scrollTop() > 200){
			jQuery(document).scrollTo("#"+MAP_DIV, 300)
		}
		parent.prepend(row);
		row.find('td').wrapInner('<div style="display: none;" />').parent().find('td > div').slideDown(500,function(){
		  var $set = $(this);
		  $set.replaceWith($set.contents());
		 });
	
		row.addClass("selected");
		
	
	}
	
}