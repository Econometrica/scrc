var util	= require('util'),
	eyes	= require('eyes'),
	async	= require('async'),
	fs		= require('fs');

//
// Retrieve all distinct years in data set
//
function getYears( fn ) {
	var query = "SELECT * from years"
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve specific site for id
//
function getSite( id, fn ) {
	var query = "SELECT * from sites where id="+id
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

//
// Retrieve all DRGS
//
function getDrgs( fn ) {
	var query = "SELECT * from drgs order by id"
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve specific DRG
//
function getDrg(id, fn ) {
	var query = "SELECT * from drgs where id="+id
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

function getSelectedDrgMeasures(fn ) {
	var query = "SELECT * from by_drg_statistics"
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}
//
// Retrieve all measures
//
function getMeasures( fn ) {
	var query = "SELECT * from measures"
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}
//
// Retrieve specific measure from measure table
//
function getMeasure(id, fn ) {
	var query = "SELECT * from measures where id="+id
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

//
// Retrieve all subpopulations
//
function getSubpopulations( fn ) {
	var query = "SELECT * from subpopulations"
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve subpopulation
//
function getSubpopulation(id, fn ) {
	var query = "SELECT * from subpopulations where id="+id
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

function get_sdsm( site_id, drg_id, subpop_id, measure_id, fn) {
	var query = "SELECT * from data where site_id="+site_id
	query += " and drg_id="+drg_id
	query += " and subpopulation_id="+subpop_id
	query += " and measure_id="+measure_id
	
	console.log(query) 
	app.client.query(query, function(err, result) {
		console.log("err:"+err)
		fn(err, result.rows)
	})
}


//
// Retrieve specific measure for site_id and control groups
//
function get_measure_year_quarter(s_id, m_id, fn ) {
	var query = "SELECT * from by_site_measure_year_quarter where measure_id="+m_id
	query += " and (site_id ="+s_id+" or site_id<10)"
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve specific measure for site_id
//
function get_site_measure_year_quarter(s_id, m_id, fn ) {
	var query = "SELECT * from by_site_measure_year_quarter where measure_id="+m_id
	query += " and (site_id ="+s_id+")"
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}
	
//
// Retrieve all domains
//
function getDomains( fn ) {
	var query = "SELECT * from domains order by id "
	console.log(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

module.exports = {
	transitions: function(req, res) {
		var id 		= req.params['id']
		var user 	= req.user
		
		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')
		
		console.log('transitions', id)
		getSite(id, function(err, result ) {
			res.render( 'aspect/transitions.ejs', {layout: 'layout.ejs', site: result});	
		})
	},

	//
	// generates JSON data for that site and that measure
	//
	site_measure: function(req,res) {
		var m_id 	= req.params['mid']
		var s_id 	= req.params['sid']
		console.log("json measure:", m_id, " site:", s_id)
		get_site_measure_year_quarter( s_id, m_id, function(err, results ) {
			var json = []
			var months = []
			for( var i in results ) {
				var r = results[i]
				var date = new Date(r.year, (r.quarter-1)*3, 1)
				var datum = [date.getTime(), r.total_value]
				json.push(datum)
			}
			//eyes.inspect(json)
			res.send(json)
		})
	},
	//
	// generates JSON data for that site ,drg, subpop, measure
	//
	sdsm: function(req, res) {
		eyes.inspect(req.query, "sdsm query");
		
		var site_id 	= req.query['site']
		var drg_id 		= req.query['drg']
		var subpop_id 	= req.query['subpop']
		var measure_id 	= req.query['measure']
		var callback	= req.query['callback']
		
		function reformat( results ) {
			var json = []
			for( var i in results ) {
				var r = results[i]
				var date = new Date(r.year, (r.quarter-1)*3, 1)
				var datum = [date.getTime(), r.value]
				json.push(datum)
			}
			return json
		}
		
		// we need to get the control groups and then get the requested site
		async.parallel([
			function(callback) {
				get_sdsm( 1, drg_id, subpop_id, measure_id, function(err, results ) {
					var data = reformat(results);
					callback(null, {site: 1,
									data: data})
				})
			},
			function(callback) {
				get_sdsm( 2, drg_id, subpop_id, measure_id, function(err, results ) {
					var data = reformat(results);
					callback(null, {site: 2,
									data: data })
				})
			},
			function(callback) {
				get_sdsm( 3, drg_id, subpop_id, measure_id, function(err, results ) {
					var data = reformat(results);
					callback(null, { site: 3,
									data: data})
				})
			},
			function(callback) {
				get_sdsm( site_id, drg_id, subpop_id, measure_id, function(err, results ) {
					var data = reformat(results);
					callback(null, {site: site_id,
									data: data })
				})
			},
		], function(err, results) {
			//eyes.inspect(results)
			if( callback ) {
				res.send(callback + '('+results+');')
			} else {
				res.send(results)
			}
		})
	},	
	
	//
	// Display a specific measure for that site & control groups
	//
	measure: function(req,res) {
		var m_id 	= req.params['id']
		var s_id	= req.query['site']
		var user 	= req.user

		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')

		console.log('measure ', m_id, ' for site:', s_id, ' user site:', user.site_id)
		
		async.parallel([
			function(callback) {
				getSite(s_id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getMeasure( m_id, function(err, result ) {
					callback(null, result)
				})
			}
		], function(err, results) {
				res.render( 'aspect/measure.ejs', 
					{	layout: 'layout.ejs', 
						site: 	results[0],
						measure: results[1]
					});	
		})
	},
	
	// Users picks a measure
	measures: function(req,res) {
		var id 		= req.params['id']
		var user 	= req.user

		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')

		console.log('measures for site:', id)
		
		async.parallel([
			function(callback) {
				getSite(id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getMeasures( function(err, result ) {
					callback(null, result)
				})
			},
			function(callback) {
				getDomains( function(err, result ) {
					callback(null, result)
				})
			}
		], function(err, results) {
			//eyes.inspect(results, 'results')
			res.render( 'aspect/measures.ejs', 
				{ 	layout: 'layout.ejs', 
					site: 		results[0],
					measures: 	results[1],
					domains:    results[2]
				});				
		})
	},

	// request for specific drg
	drg: function(req,res) {
		//eyes.inspect(req.body, "body")
		var id 		= req.body['site']
		var drg 	= req.body['drg']
		var subpop 	= req.body['subpop']
		var user 	= req.user

		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')
		
		var arr		= drg.split(' ')
		var drg_id	= arr[0]
		
		async.parallel([
			function(callback) {
				getSite(id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getSubpopulation(subpop, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getDrg(drg_id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getSelectedDrgMeasures( function(err, result ) {
					//eyes.inspect(result)			
					callback(null, result)
				})
			}
			
		], function(err, results) {
			res.render( 'aspect/drg.ejs', 
				{	layout: 'layout.ejs', 
					host: 		"http://localhost:7464",
					site: 		results[0],
					subpop:		results[1],
					drg: 		results[2],
					measures: 	results[3]
				});	
		})
	},
	
	// select DRG form
	drgs: function(req,res) {
		var id 		= req.params['id']
		var user 	= req.user
		console.log('drgs', id)
		
		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')
		
		async.parallel([
			function(callback) {
				getSite(id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getDrgs( function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getSubpopulations( function(err, result ) {
					eyes.inspect(result, "subpop")
					callback(null, result)
				})
			},
		], function(err, results) {
			res.render( 'aspect/drgs.ejs', 
				{	layout: 'layout.ejs', 
					site: 			results[0],
					drgs: 			results[1],
					subpopulations: results[2],
				});	
		})
	},
	
	// Benchmark selection form
	benchmarks:  function(req,res) {
		var id 		= req.params['id']
		var user 	= req.user
		console.log('benchmarks', id)
		
		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')
		
		async.parallel([
			function(callback) {
				getSite(id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getYears( function(err, result ) {	
					eyes.inspect(result, "years")				
					callback(null, result)
				})
			},
			function(callback) {
				getDrgs( function(err, result ) {					
					callback(null, result)
				})
			}
		], function(err, results) {
			res.render( 'aspect/benchmarks.ejs', 
				{	layout: 	'layout.ejs', 
					site: 		results[0],
					years: 		results[1],
					drgs: 		results[2],
					user: 		user,
				});	
		})
	},
	
	// Specific Benchmark rendering
	benchmark:  function(req,res) {
		var id 		= req.body['site']
		var drg 	= req.body['drg']
		var year 	= req.body['year']
		var quarter	= req.body['quarter']
		var user 	= req.user
		
		eyes.inspect(req.body, "body")
		
		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')
		
		var arr		= drg.split(' ')
		var drg_id	= arr[0]
		
		console.log("benchmark", id, drg, year, quarter, drg_id)
		 
		async.parallel([
			function(callback) {
				getSite(id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getDrg(drg_id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getSelectedDrgMeasures( function(err, result ) {
					callback(null, result)
				})
			}
		], function(err, results) {
			res.render( 'aspect/benchmark.ejs', 
				{	layout: 	'layout.ejs', 
					site: 		results[0],
					drg: 		results[1],
					data: 		results[2],
					year: 		year,
					quarter: 	quarter,
					user: 		user
				});	
		})
	}
}
