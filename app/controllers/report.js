var util 		= require('util');
var fs	 		= require('fs');
var path		= require('path');
var debug		= require('debug')('report');

module.exports = {
	index: function(req, res) { 
		console.log("Start report...")      
		var user=req.user;
		res.render("report/index", {layout: true, user:user})
	},
	
	fix: function(req, res) { 
		console.log("Start report...")      
		var user=req.user;
		var sites = JSON.parse(fs.readFileSync("./public/sites.json"));
		var index = 1
		for( var s in sites ) {
			var site = sites[s]
			site.name = "site"+index;
			index += 1
			
		//	if( index > 100 ) {
		//		site.region = "NJ"
		//	} else if( index > 50 ) {
		//		site.region = "FL"			
		//	} else {
		//		site.region = "IL"
		//	}
		}
		console.log("index:"+index)
		
		fs.writeFileSync( "./public/sites2.json", JSON.stringify(sites))
		//res.render("report/index", {layout: true, user:user})
		res.send("Done");
	},
	test: function(req, res) { 
		console.log("test report...")      
		var user=req.user;
		var sites = JSON.parse(fs.readFileSync("./public/sites2.json"));
		res.send("Done");
	}
	
};