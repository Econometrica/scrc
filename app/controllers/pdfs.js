var util	= require('util'),
	eyes	= require('eyes'),
	async	= require('async'),
	fs		= require('fs'),
	queries = require('../../lib/queries.js')
	path	= require('path');
	
	var url_base  	= "https://s3.amazonaws.com"

module.exports = {
	cms: function(req, res) {
		var user 		= req.user;
		var year		= req.params['year'];
		var quarter		= req.params['quarter'];
		
		console.log("Get pdfs for ", year, quarter )
		
		function getPdf( site, callback ) {
			var bucket = site.bucket;
			app.s3.listObjects({Bucket: site.bucket}, function (err, data) {
				var files = {}
				if( err === null ) {
					//console.log(site.name, site.bucket)
					for( var d in data.Contents ) {
						var datum 		= data.Contents[d]
						var key 		= datum.Key
						var arr			= key.split(".")
						var url 		= path.join(url_base, site.bucket, key)
						var base		= arr[0]
						var base_arr	= base.split('_')
						var ext			= arr[1]
						var fyear		= base_arr[0]
						var fquarter	= base_arr[1]
						//console.log( fyear, fquarter, year, quarter)
						if( (fyear === year) && (fquarter === quarter)) {
							//console.log("Found doc at ", url)
							if( files[base] === undefined ) {
								files[base] = {}
								files[base][ext] = url
							} else {
								files[base][ext] = url
							}
						}
					}
					site.files = files
					//eyes.inspect(site, "site")
					callback( 0, site)
				} else {
					callback( 0, {})
				}
			})
		}
		
		queries.getSites( function(err, sites) {
			async.map(sites, getPdf, function(err, results) {
				//eyes.inspect(results, "pdf results")
				function filterIt( e, callback) {
					callback(Object.keys(e).length > 0); 
				}
				async.filter( results, filterIt , function(data) {
					eyes.inspect(data, "pdf data")
					res.send(data)					
				})
			})
		});
	},
	index: function(req, res) {
		var user 		= req.user;
		console.log("Get pdfs for ", user.site_id )
		if( user.site_id == 0 ) {
			return res.render("pdfs/cms", {layout:true, user:user, host: req.headers['host']})
		}
		if( user.site_id != 0 ) {
			queries.getSite(user.site_id, function(err, result) {
				//eyes.inspect(result)
				app.s3.listObjects({Bucket: result.bucket}, function (err, data) {
					//eyes.inspect(data, "data")
					var files = {}
					for( var d in data.Contents ) {
						var datum 	= data.Contents[d]
						//eyes.inspect(datum, "datum")
						var key 	= datum.Key
						var arr		= key.split(".")
						var url 	= path.join(url_base, result.bucket, key)
						var quarter	= arr[0]
						var ext		= arr[1]
						
						if( files[quarter] === undefined ) {
							files[quarter] = {}
							files[quarter][ext] = url
						} else {
							files[quarter][ext] = url							
						}
						//console.log( "add file:", arr[0], arr[1], url)
					}
					result.files = files
				  	//eyes.inspect(result, "bucket data");
					res.render("pdfs/index", { layout:true, user:user, site: result, result:result})
				});
				
			})
		} else {
			res.send("NOT IMPLEMENTED YET!")
		}
	}
};