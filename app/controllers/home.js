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
						"id": row.id,
						"image": row.image,
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
		eyes.inspect(req.headers, "headers")
		eyes.inspect(req.user, "user")
		async.parallel([
			function(callback) {
				getSitesGeoJSON( req.user, function(err, result ) {
					callback(err, result)
				})
			},
			function(callback) {
				getSummary( req.user.site_id, function(err, result ) {
					eyes.inspect(result, "summary")
					callback(err, result)
				})
			},
		], function(err, results) {
				//eyes.inspect(results[0], "sites")
				eyes.inspect(results[1], "summary")
				
				res.render( 'home/index.ejs', 
					{ 	layout: "layout.ejs",
						geojson: results[0],
						summary: results[1].summary });
		})
	}
};