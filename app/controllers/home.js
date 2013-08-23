var util	= require('util'),
	async	= require('async'),
	eyes	= require('eyes'),
	fs		= require('fs');
	
	var icons = [ "", 
					"image030.gif", 
					"image061.gif",
					"image063.gif",
					"image046.gif",
				]
		
function getSummary(id, fn) {
	var query = "SELECT * from summaries where id="+id
	app.client.query(query, function(err, result) {
		//eyes.inspect(result, "summary")
		fn(err, result.rows[0])
	})
}	
	
function getSitesGeoJSON( user, fn ) {
	var query = "SELECT * from sites"
	app.client.query(query, function(err, result) {
		geojson = {
			"type": "FeatureCollection",
			  "features": []
		}
		
		var iconUrl;
		
		
		for( var r in result.rows ) {
			var row = result.rows[r]

			if( user.site_id == 0 || user.site_id != row.id ) {
				iconUrl = "img/"+icons[4]
			} else {
				iconUrl = "img/"+icons[3]
			}

			if( row.id >= 10 ) {
				var feature = {
					"type": "Feature",
					"geometry": {
						"type": "Point", 
						"coordinates": [ row.longitude, row.latitude ] },
					"properties": {
						"title": row.name,
						"website": row.website,
						"address": row.address,
						"state": row.state,
						"id": row.id,
						"rank": parseInt(Math.random()*100),
						"image": '/img/logos/'+row.id+".jpg",		//row.image,
						"icon": {
							//"iconUrl": "img/"+icons[row.ownership_id],
							"iconUrl": iconUrl,
							"iconSize": [10, 10], // size of the icon
				            "iconAnchor": [5, 5], // point of the icon which will correspond to marker's location
				            "popupAnchor": [-25, -25]  // point from which the popup should open relative to the iconAnchor
						}
					} 
				}
				geojson.features.push(feature)
			}
		}
		fn(err, geojson);
	})
}
module.exports = {
	about: function(req, res) {
		res.render( 'home/about.html', {layout: false});
	},
	
	contact: function(req, res) {
		res.render( 'home/contact.html', {layout: false});
	},
	
	sites: function(req, res) {
		getSitesGeoJSON( function( err, geojson ) {
			res.send( geojson )
		}) 
	},
	
	index: function(req, res) {
		//eyes.inspect(req.headers, "headers")
		//eyes.inspect(req.user, "user")
		var user = req.user;
		var latitude, longitude, zoom;
		
		if( user.site_id == 0 ) {
			latitude 	= 37.0
			longitude 	= -99.0
			zoom 		= 4
		} else {
			zoom = 8
		}
		
		async.parallel([
			function(callback) {
				getSitesGeoJSON( req.user, function(err, result ) {
					if( user.site_id != 0 ) {
						for( r in result.features ) {
							if( result.features[r].properties.id === user.site_id ) {
								var coordinates = result.features[r].geometry.coordinates
								latitude 	= coordinates[1]
								longitude	= coordinates[0]
								break
							}
						}
					}
					result.features = result.features.sort( function(a,b) { 
						if (a.properties.title > b.properties.title)
						      return 1;
						if (a.properties.title < b.properties.title)
						      return -1;
						// a must be equal to b
						return 0; })
					callback(err, result)
				})
			},
			function(callback) {
				getSummary( req.user.site_id, function(err, result ) {
					callback(err, result)
				})
			},
		], function(err, results) {
				res.render( 'home/index.ejs', 
					{ 	layout: "layout.ejs",
						geojson: results[0],
						summary: results[1].summary,
						user: 	 req.user,
						latitude: latitude,
						longitude: longitude,
						zoom: zoom });
		})
	}
};