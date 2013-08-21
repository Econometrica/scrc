var util	= require('util'),
	eyes	= require('eyes'),
	async	= require('async'),
	fs		= require('fs');

//
// Retrieve all distinct years in data set
//
function getYears( fn ) {
	var query = "SELECT * from years"
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}
//
// Retrieve all quick measures for transitional care
//
function getQuickMeasures( fn ) {
	var query = "SELECT * from joined_quick_statistics"
	logger.info(query) 
	app.client.query(query, function(err, result) {
		//eyes.inspect(result, "getQuickMeasures")
		fn(err, result.rows)
	})
}

//
// Get Quick Statistics for Particular Site and Department
// and generate the quick stats
//
function getQuickStatsData(site_id, dept_id, measures, fn ) {
	var query = "SELECT * from transitional_care_data where site_id="+site_id+" and department_id="+dept_id
	logger.info(query) 
	app.client.query(query, function(err, results) {
		var result			= results.rows
		var data 			= []
		var measure_id 		= 0
		
		function findMeasure(id) {
			for(var m in measures ) {
				if( measures[m].id == id ) return measures[m]
			}
			logger.info("measure:", id, "not found")
			return null;
		}
		
		for( var r in result ) {
			var elt  = result[r]
			var next = parseInt(r)+1
			if( elt.measure_id != measure_id ) {
				var measure = findMeasure(elt.measure_id)
				//eyes.inspect(measure, "measure")
				var d = {
					site_id: 	site_id,
					measure_id: elt.measure_id,
					measure:    measure.name,
					val: 		elt.value,
					delta:      elt.value - result[next].value
				}
				//eyes.inspect(d, "d")
				
				data.push(d)
				measure_id = elt.measure_id
			}
		}
		fn(err, data)
	})
}
	
//
// Retrieve specific all sites
//
function getSites( fn ) {
	var query = "SELECT * from sites"
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}
	
//
// Retrieve specific site for id
//
function getSite( id, fn ) {
	var query = "SELECT * from sites where id="+id
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

//
// Retrieve all DRGS
//
function getDrgs( fn ) {
	var query = "SELECT * from drgs order by id"
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve specific DRG
//
function getDrg(id, fn ) {
	var query = "SELECT * from drgs where id="+id
	logger.info(query) 
	app.client.query(query, function(err, result) {
		console.log(err)
		if( !err && result.rows) {
			fn(err, result.rows[0])
		} else {
			fn(err, null)
		}
	})
}

function getSelectedDrgMeasures(fn ) {
	var query = "SELECT * from by_drg_statistics"
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}
//
// Retrieve all measures
//
function getMeasures( fn ) {
	var query = "SELECT * from measures"
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}
//
// Retrieve specific measure from measure table
//
function getMeasure(id, fn ) {
	var query = "SELECT * from measures where id="+id
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

//
// Retrieve all subpopulations
//
function getSubpopulations( fn ) {
	var query = "SELECT * from subpopulations"
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve specific subpopulation
//
function getSubpopulation(id, fn ) {
	var query = "SELECT * from subpopulations where id="+id
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

function get_sdsm( site_id, drg_id, subpop_id, measure_id, fn) {
	var query = "SELECT * from data where site_id="+site_id
	query += " and drg_id="+drg_id
	query += " and subpopulation_id="+subpop_id
	query += " and measure_id="+measure_id
	query += " and episode_id=0"
	
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}


function get_benchmark_sdsm( site_id, drg_id, subpop_id, measure_id, year, quarter, fn) {
	var query = "SELECT site_id, episode_id, value from drgs_benchmark_data where "
	query += " drg_id="+drg_id
	query += " and subpopulation_id="+subpop_id
	query += " and measure_id="+measure_id
	query += " and year="+ year
	query += " and quarter="+quarter
	query += " order by site_id, episode_id"
	
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve specific measure for site_id and control groups
//
function get_measure_year_quarter(s_id, m_id, fn ) {
	var query = "SELECT * from by_site_measure_year_quarter where measure_id="+m_id
	query += " and (site_id ="+s_id+" or site_id<10)"
	logger.info(query) 
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
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}
	
//
// Retrieve all domains
//
function getDomains( fn ) {
	var query = "SELECT * from domains order by id "
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve all departments
//
function getDepartments( fn ) {
	var query = "SELECT * from departments where id>0"
	logger.info(query) 
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

module.exports = {
	// display transitions of care for particualr site
	transitions: function(req, res) {
		var id 		= req.params['id']
		var user 	= req.user
		
		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')
		
		logger.info('transitions', id)
		async.parallel([
			function(callback) {	
				getSite(id, function(err, result ) {
					callback( err, result);	
				})
			},
			function(callback) {	
				getDepartments( function(err, result ) {
					callback( err, result);	
				})
			}], function(err, results) {
					res.render( 'aspect/transitions.ejs', {
						layout: 'layout.ejs', 
						user: user,
						site: results[0],
						departments: results[1]});
			});
	},
	
	// get transitions of care for specific site and department
	transitions_department: function(req, res) {
		var site_id = req.params['site_id']
		var dept_id = req.params['dept_id']
		var user 	= req.user
		
		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')
		
		logger.info('dept transitions of care, site:', site_id, 'dept:', dept_id)
		
		try {
			getQuickMeasures(function(err, mresult ) {
				var measures = mresult
				async.parallel([
					function(callback) {
						getQuickStatsData(1, dept_id, measures, function(err, result ) {
							callback( null, result);	
						})
					},
					function(callback) {
						getQuickStatsData(2, dept_id, measures, function(err, result ) {
							callback( null, result);	
						})
					},
					function(callback) {
						getQuickStatsData(3, dept_id, measures, function(err, result ) {
							callback( null, result);	
						})
					},
					function(callback) {
						getQuickStatsData(site_id, dept_id, measures, function(err, result ) {
							callback( null, result);	
						})
					},
				], function(err, results) {
					var ctrl1 		= results[0]
					var ctrl2 		= results[1]
					var ctrl3		= results[2]
					var measures	= results[3]
					
					for( var m in measures ) {
						measures[m].ctrl1 = ctrl1[m].val
						measures[m].ctrl2 = ctrl2[m].val
						measures[m].ctrl3 = ctrl3[m].val
					}
					//eyes.inspect(measures, "measures")
					res.send(measures);
				})
			})
		} catch(err) {
			logger.info('getQuickMeasures exception:', err)
		}
	},
	//
	// generates JSON data for that site and that measure
	//
	site_measure: function(req,res) {
		var m_id 	= req.params['mid']
		var s_id 	= req.params['sid']
		logger.info("json measure:", m_id, " site:", s_id)
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
		//eyes.inspect(req.query, "sdsm query");
		
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

		if( user.site_id != 0 && user.site_id != s_id ) {
			return res.send('Sorry!!! UnAuthorized')
		}
		
		logger.info('measure ', m_id, ' for site:', s_id, ' user site:', user.site_id)
		
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
						measure: results[1],
						user: user
					});	
		})
	},
	
	// Users picks a measure
	measures: function(req,res) {
		var id 		= req.params['id']
		var user 	= req.user

		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')

		logger.info('measures for site:', id)
		
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
					domains:    results[2],
					user:       user
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
					host: 		"http://"+ req.headers['host'],
					site: 		results[0],
					subpop:		results[1],
					drg: 		results[2],
					measures: 	results[3],
					user: 		user
				});	
		})
	},
	
	// select DRG form
	drgs: function(req,res) {
		var id 		= req.params['id']
		var user 	= req.user
		logger.info('drgs', id)
		
		var sel_drg 	= -1;
		var sel_subpop 	= -1;
		if( req.query ) {
		 	sel_drg = req.query['drg']
			sel_subpop = req.query['subpop']
			console.log(sel_drg, sel_subpop)
		}
			
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
					//eyes.inspect(result, "subpop")
					callback(null, result)
				})
			},
		], function(err, results) {
			res.render( 'aspect/drgs.ejs', 
				{	layout: 'layout.ejs', 
					site: 			results[0],
					drgs: 			results[1],
					subpopulations: results[2],
					user: 			user,
					sel_drg: 		sel_drg,
					sel_subpop: 	sel_subpop
				});	
		})
	},
	
	// Benchmark selection form
	benchmarks:  function(req,res) {
		var id 		= req.params['id']
		var user 	= req.user
		
		logger.info('benchmarks', id)
		
		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')

		var sel_drg 	= -1;
		var sel_subpop 	= -1;
		var sel_year	= -1;
		var sel_quarter	= -1;
		
		if( req.query ) {
		 	sel_drg 	= req.query['drg']
			sel_subpop = req.query['subpop']
			sel_year 	= req.query['year']
			sel_quarter = req.query['quarter']
		}
		
		async.parallel([
			function(callback) {
				getSite(id, function(err, result ) {					
					callback(null, result)
				})
			},
			function(callback) {
				getYears( function(err, result ) {	
					//eyes.inspect(result, "years")				
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
					callback(null, result)
				})
			}
		], function(err, results) {
			res.render( 'aspect/benchmarks.ejs', 
				{	layout: 		'layout.ejs', 
					site: 			results[0],
					years: 			results[1],
					drgs: 			results[2],
					subpopulations: results[3],
					user: 			user,
					sel_year: 		sel_year,
					sel_quarter: 	sel_quarter,
					sel_drg: 		sel_drg,
					sel_subpop: 	sel_subpop
				});	
		})
	},
	
	// ajax support
	benchmark_sdmp: function(req, res) {
		var site_id = req.params['site_id']
		var drg_id 	= req.params['drg_id']
		var m_id	= req.params['m_id']
		var pop_id 	= req.params['pop_id']
		var year 	= req.params['year']
		var quarter = req.params['quarter']
		
		logger.info( "benchmark_sdmp", site_id, "drg:",drg_id, "measure:",m_id, "subpop:", pop_id, year, quarter)
		
		function reformat( results ) {
			var series = [ 
							{ episode_id: 1, name:'Pre-Episode', data:[]},
							{ episode_id: 2, name:'Current Episode', data:[]},
							{ episode_id: 3, name:'Post-Episode', data:[]}
			 ]
		
			for( var i in results ) {
				var r = results[i]
				
				if( r.site_id == site_id ) {
					var x = site_id
					var y = r.value;
					r.value = { x: x, y: y, borderWidth:'3', borderColor: 'black' }
				} else {
					var x = r.site_id
					var y = r.value;
					r.value = { x: x, y: y }
					
				}
				
				series[r.episode_id-1].data.push( r.value )
			}
			return series
		}
		
		get_benchmark_sdsm( site_id, drg_id, pop_id, m_id, year, quarter, function(err, results) {
			// reformat
			//eyes.inspect(results, "sdmp results")
			var data = reformat(results)
			//eyes.inspect(data, "sdmp data")
			res.send( data )
		})
	},
	
	// Specific Benchmark rendering
	benchmark:  function(req,res) {
		var id 		= req.body['site']
		var drg 	= req.body['drg']
		var year 	= req.body['year']
		var quarter	= req.body['quarter']
		var subpop	= req.body['subpop']
		var user 	= req.user
		
		//eyes.inspect(req.body, "body")
		//eyes.inspect(req.headers, "headers")
		
		if( user.site_id != 0 && user.site_id != id ) return res.send('Sorry!!! UnAuthorized')
		
		var arr		= drg.split(' ')
		var drg_id	= arr[0]
		
		logger.info("benchmark", id, drg, year, quarter, drg_id)
		 
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
			},
			function(callback) {
				getSubpopulation( subpop, function(err, result ) {
					callback(null, result)
				})
			},
			function(callback) {
				getSites( function(err, result ) {
					// if user is not CMS, we need to obfuscte the site names
					//eyes.inspect(user, "user site check");
					if( user.site_id != 0 ) {
						for( var s in result ) {
							if( result[s].id > 9 )  {	// Control Groups
								if( result[s].id != user.site_id ) {
									result[s].name = 'site '+result[s].id;
									//logger.info("Obfuscate ", result[s].id, " to ", result[s].name)
								}
							}
						}
					}
					//eyes.inspect(result, "sites")
					callback(null, result)
				})
			}
		], function(err, results) {
			res.render( 'aspect/benchmark.ejs', 
				{	layout: 		'layout.ejs', 
					site: 			results[0],
					drg: 			results[1],
					measures: 		results[2],
					subpopulation: 	results[3],
					sites:  		results[4],
					host: 			"http://" + req.headers['host'],
					year: 			year,
					quarter: 		quarter,
					user: 			user,
				});	
		})
	}
}
