

function is_empty(o){
	return o == null || o == undefined || o == '';
}



function Gmapper(div, opt){
	//console.log("Gmapper new")
	

	this.div_id = div;	
	this.gmarkers = [];
	this.bounds = new google.maps.LatLngBounds();
	this.info_window = new google.maps.InfoWindow();
	this.default_icon = opt.default_icon
	
	//console.log('bounds initialized');

	this.allowed_bounds = new google.maps.LatLngBounds(
	  		new google.maps.LatLng(39.097, -74.5), 
	     	new google.maps.LatLng(41.15, -72.5));

	//console.log(' allowed bounds initialized');
	this.map_type = is_empty(opt.map_type) ? "ROADMAP" : opt.map_type
	//console.log("maptype: " + this.map_type);
		
	this.min_zoom_level = 8;
	this.default_zoom = is_empty(opt.default_zoom) ? 13 : opt.default_zoom;
	this.map_options = {
  			mapTypeId: google.maps.MapTypeId[this.map_type],
			//  zoom: this.min_zoom_level,
			  center: new google.maps.LatLng(40.7791544,-73.962697),
			  disableDefaultUI: true,
			  navigationControl: true,
		    
			  navigationControlOptions: {
			    style: google.maps.NavigationControlStyle.SMALL
			  },
  
//			  mapTypeControl: true,
//			  mapTypeControlOptions: {
			        //style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
//			      },
			  scaleControl: true
	}
	
	this.map_style_options = [{featureType:"road",elementType:"geometry",stylers:[{lightness:75}]},{featureType:"all",elementType:"all",stylers:[{saturation:-80}]},{featureType:"poi",elementType:"labels",stylers:[{visibility:"off"}]},{featureType:"landscape",elementType:"labels",stylers:[{visibility:"off"}]},{featureType:"administrative.locality",elementType:"labels",stylers:[{visibility:"off"}]},{featureType:"administrative.land_parcel",elementType:"labels",stylers:[{visibility:"off"}]}];
	
	
	this.gmap = new google.maps.Map(document.getElementById(this.div_id), this.map_options);
	//console.log("gmap initialized")
	this.gmap.setMapTypeId('eyeheart');
	
	
	this.gmap_type = new google.maps.StyledMapType(this.map_style_options, {name:'eyeheart', map:this.gmap});
		this.gmap.mapTypes.set('eyeheart', this.gmap_type);
	
	
	
	
	//event listeners
	var _gmapper = this;
	
	google.maps.event.addListener(_gmapper.gmap, 'zoom_changed', function() {
		//console.log("ZOOM: " + _gmapper.gmap.getZoom());  
		
    // if (_gmapper.gmap.getZoom() < _gmapper.min_zoom_level) _gmapper.gmap.setZoom(_gmapper.min_zoom_level);
   });


	
	
	//functions
	
	this.add_markers = function(arr){
		for(var i in arr){
			this.create_marker(arr[i]);
		}
	}
	
	this.create_marker = function(opt){
		if(is_empty(opt.icon) && !is_empty(this.default_icon)) opt.icon = this.default_icon;
		
		var mk = new Gmarker(this, opt);
		this.gmarkers.push(mk)
		return mk;
	}
	
	_gmapper = this;
	this.draw_marker = function(gmarker){
		gmarker.draw();
		this.extend_bounds_to_marker(gmarker);
		google.maps.event.addListener(gmarker.marker, 'click', function(){
			_gmapper.show_map_info_div(gmarker)
			_gmapper.open_info_window(gmarker)
		})
		
		return gmarker;
	}
	
	this.draw_markers = function(){
		for(var i in this.gmarkers){
			this.draw_marker(this.gmarkers[i]);
		}
	}
	
	
	this.extend_bounds_to_marker = function(gmarker){
		this.bounds.extend(gmarker.get_position());
		return this.bounds
	}
	
	this.remove_marker = function(gmarker){
		
		this.bounds = new google.maps.LatLngBounds();
		this.gmarkers.splice(this.gmarkers.indexOf(gmarker), 1)
		for(var i in this.gmarkers){
			this.bounds.extend(this.gmarkers[i].get_position())
		}
		gmarker.remove();
		return this.bounds
		
	}
	
	this.undraw_marker = function(gmarker){
		gmarker.undraw();
		return gmarker;
	}

	this.open_info_window = function(gmarker){
		this.close_info_window();
		this.info_window.setContent(gmarker.content);
		this.info_window.open(this.gmap, gmarker.marker);
	}
	this.close_info_window = function(){
		this.info_window.close();
	}
	
	this.resize_map_to_bounds = function(opt){
		
		this.gmap.fitBounds(this.bounds);
		//console.log("BOUNDS: " + this.bounds);  
		
		/*
		if(parseInt(opt.zoom) > 0){
			this.gmap.setZoom(parseInt(t_zoom));
		}
		*/
	}
	
	this.show_map_info_div = function(gmarker){
	//	//console.log("show_map_info_div: " + gmarker.title);
	}
	
	this.get_marker_by_id = function(gid){
		for(var i in this.gmarkers){
			if(this.gmarkers[i].id == gid) return this.gmarkers[i];
		}
		return false;
	}
	
	this.focus_on_marker = function(gmarker){
		this.gmap.setZoom(this.default_zoom)
		this.gmap.panTo(gmarker.get_position());
		
	}
}

function Gmarker(_gmapper, opt){
	this.gmapper = _gmapper;
	this.id = opt.id;
	this.gmap = this.gmapper.gmap
	this.lat = opt.lat;
	this.lng = opt.lng;
	this.title = opt.title;
	this.address = opt.address
	this.info = opt.info;
	this.icon= opt.icon;
	this.flat = opt.flat==false ? false : true;
	this.foo_click = opt.foo_click;
	this.marker = new google.maps.Marker({ 
		position: new google.maps.LatLng(this.lat, this.lng),
		title: this.title,
		icon: this.icon,
		flat: this.flat
	})
	
	this.content =  "<div class='info_window'><h3>"+this.title+"</h3><div class='info'>"+this.info+"</div></div>"
	
	var g_this = this;
	google.maps.event.addListener(g_this.marker, 'click', function(){
		g_this.gmapper.open_info_window(g_this);
		if(!is_empty(g_this.foo_click)){
			g_this.foo_click();
		}
	})
	
	
	this.draw = function(){
		this.marker.setMap(this.gmap);
	}
	
	this.remove = function(){
		//clean up function
	}
	
	this.undraw = function(){
		this.marker.setMap(null);
	}
	
	this.get_position = function(){
		//wrapper for GMarker's getPosition
		return this.marker.getPosition();
	}
	
}


