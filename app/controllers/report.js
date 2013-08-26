var util 		= require('util');
var fs	 		= require('fs');
var path		= require('path');
var debug		= require('debug')('report');
var async		= require('async');
var eyes		= require('eyes');
var queries		= require('../../lib/queries.js');

function fixAttr(name, arr) {
	var len = arr.length;
	console.log(name, arr.length)
	var index = 0
	var new_arr = []
	for( var a in arr ) {
		var el 		= arr[a];
		var year 	= 2000 + index
		el[0] 		= year
		index += 1
		new_arr.push( el)
		if( index == 14 ) break
	}
	return new_arr
}

function getMeasureData( site, measures, year, quarter, callback) {
	//eyes.inspect(measures, "measures")
	function getSpecificMeasureData(meas, fn) {
		//eyes.inspect(meas, "meas")
		queries.get_by_site_measure_year_quarter(site, meas.id, year, quarter, function(err, result) {
			var value;
			
			if( result && result.total_value ) {
				value = result.total_value
			} else {
				value = parseInt(Math.random()*100)
			}
			var data = { name: meas.name, value: value, url: "/site/measure/"+meas.id+"?site="+site}
			//eyes.inspect(data, "data")
			fn(err, data)
		})
	}
	async.map(measures, getSpecificMeasureData, function(err, results) {
		callback(err, results)
	})
}

module.exports = {
	index: function(req, res) { 
		var sites = JSON.parse(fs.readFileSync("./public/sites2.json"));
		console.log("Start report...")      
		var user=req.user;
		res.render("report/index", {layout: true, user:user})
	},
	treemap: function(req, res) {
		var site = req.params['id']
		var user = req.user
		queries.getSite( site, function( err, result ) {
			res.render("report/treemap2", { layout: true, user: user, site: result })
		})
	},
	treemap_gen: function(req, res) {
		var site = req.params['id']
		async.parallel([
			function(callback) {
				queries.getDomains( function(err, result ) {
					callback( err, result);	
				})
			},	
			function(callback) {
				queries.getMeasures( function(err, result ) {
					callback( err, result);	
				})
			}
		], function(err, results) {
			var domains 	= results[0]
			var measures 	= results[1]
			var treemap 	= { name: 'treemap', children: []}
			
			//eyes.inspect(measures, "measures")
			for( var d in domains) {
				var domain = domains[d]
				var child  = { name: domain.name, children: []}
				for( var m in measures ) {
					var measure = measures[m]
					if( measure.domain_id === domain.id ) {
						child.children.push( measure)
					}
				}
				treemap.children.push(child)
			}
			
			function getDomainMeasuresData( domain, callback ) {
				//eyes.inspect(domain, "domain")
				var measures  = domain.children
				
				// find measures for that domain
				getMeasureData( site, measures, 2012, 4, function(err, result) {
					domain.children = result
					callback(err, domain)
				})
			}
			
			async.map( treemap.children, getDomainMeasuresData, function(err, results) {
				treemap.children = results
				fs.writeFileSync( "./public/treemap_"+site+".json", JSON.stringify(treemap))
				
				res.send( treemap)
			}) 
		})
	},
	fix: function(req, res) { 
		console.log("Start report...")      
		var user=req.user;
		var sites = JSON.parse(fs.readFileSync("./public/nations.json"));
		var index = 1
		for( var s in sites ) {
			var site 	= sites[s]
			site.name 	= "site"+index;
			index 		+= 1
			var income 				= site.income
			var population 			= site.population
			var lifeExpectancy 		= site.lifeExpectancy
			//sites[s].income 		= fixAttr("income", income)
			//sites[s].population 	= fixAttr("population", income)
			//sites[s].lifeExpectancy = fixAttr("lifeExpectancy", income)
			
		//	if( index > 100 ) {
		//		sites[s].region = "NJ"
		//	} else if( index > 50 ) {
		//		sites[s].region = "FL"			
		//	} else {
		//		sites[s].region = "IL"
		//	}
		}
		//console.log("index:"+index)
		
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