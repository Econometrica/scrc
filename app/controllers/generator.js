var util	= require('util'),
	eyes	= require('eyes'),
	async	= require('async'),
	fs		= require('fs');

	var sites 			= [	1,2,3,
							10,11,12,13,14,15,16,17,18,19,
							20,21,22,23,24,25,26,27,28,29,
							30,31,32,33 ]
	
	var drgs 			= [ 163, 238, 469 ]
	var measures		= [	4, 5, 6, 7, 8, 9, 10 ]
	var max				= [	10, 20, 200, 20, 30, 10, 100 ]
	var subpop			= [	1, 2, 3 ]
	var quarters		= [	1, 2, 3, 4 ]
	var departments		= [	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 ]
	
	var years			= [	2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012 ]
	var episodes		= [	0, 1, 2, 3 ]
	var subpopulations 	= [1,2,3]
	
	//
	// generate quick stats for departments
	//
	function generate_quick_stats( fname, index ) {
		for( var s in sites ) {
			for( var d in departments) {
				for( var m in measures ) {
					for( var y in years ) {
						for( var q in quarters ) {
							var site_id 		= sites[s]
							var department_id	= departments[d]
							var measure_id		= measures[m]
							var year			= years[y]
							var  quarter		= quarters[q]
							var val 			= Math.floor((Math.random()* max[m])+1); 

							var ub 				= val + Math.floor((Math.random() * 3 )+1); 
							var lb 				= val - Math.floor((Math.random() * 3 )+1); 
						
							if( lb<0 ) 			lb = 0
						
							drg_id 				= 0 	// ALL
							episode				= 0		// ALL
							subpop				= 0;	// ALL
							
							var str = index +"," + site_id + "," + drg_id + "," + subpop + ","
							str += measure_id + "," + year + "," + quarter + "," + val + ","
							str += ub + "," + lb  + ","
							str += episode + "," + department_id + "\n"
						
							fs.appendFileSync(fname, str)
						
							index += 1
						}
					}
				}
			}
		}
		return index	
	}
	
	//
	// generate data for measures run charts
	//
	function generate_measures_data( fname, index ) {
		for( var s in sites ) {
				for( var m in measures ) {
					for( var y in years ) {
						for( var q in quarters ) {
							var site_id 	= sites[s]
							var measure_id	= measures[m]
							var year		= years[y]
							var quarter		= quarters[q]
							var val 		= Math.floor((Math.random()* max[m])+1); 
							var ub 			= val + Math.floor((Math.random() * 3 )+1); 
							var lb 			= val - Math.floor((Math.random() * 3 )+1); 
							
							if( lb<0 ) 		lb = 0
							
							drg_id			= 0;	// ALL
							subpop			= 0;	// ALL
							episode 		= 0;	// ALL
							department		= 0;	// ALL 
							
							var str = index +"," + site_id + "," + drg_id + "," + subpop + ","
							str += measure_id + "," + year + "," + quarter + "," + val + ","
							str += ub + "," + lb  + ","
							str += episode + "," + department + "\n"
							
							fs.appendFileSync(fname, str)
							
							index += 1
						}
					}
				}
			
		}
		return index	
	}
	
	//
	// generate data for drgs run/benchmark charts
	//
	function generate_drgs_data( fname, index ) {
		for( var s in sites ) {
			for( var d in drgs  ) {
				for( var m in measures ) {
					for( var p in subpopulations ) {
						for( var y in years ) {
							for( var q in quarters ) {
								for( var e in episodes ) {
									var site_id 	= sites[s]
									var drg_id		= drgs[d]
									var measure_id	= measures[m]
									var year		= years[y]
									var quarter		= quarters[q]			// 1..4
									var subpop 		= subpopulations[p];	// 1..3
									var episode		= episodes[e]			// 0..3
									var department	= 0						// ALL
								
									var val 		= Math.floor((Math.random()* max[m])+1); 
									var ub 			= val + Math.floor((Math.random() * 3 )+1); 
									var lb 			= val - Math.floor((Math.random() * 3 )+1); 
							
									if( lb<0 ) 		lb = 0
								
									var str = index +"," + site_id + "," + drg_id + "," + subpop + ","
									str += measure_id + "," + year + "," + quarter + "," + val + ","
									str += ub + "," + lb + ","
									str += episode + "," + department + "\n"
							
									fs.appendFileSync(fname, str)
							
									index += 1
								}
							}
						}
					}
				}
			}
		}
		return index
	}
	
	module.exports = {
		 
	// generate simulated data
	index: function(req, res) {
		var index 	= 1
		var fname	= '/Users/patrice/Development/scrc/data.csv'

		fs.writeFileSync(fname, "id, site_id, drg_id, subpopulation_id, measure_id, year, quarter, value, upper_bound, lower_bound, episode_id, department_id\n")
		
		// generate quick stats for departments
		logger.info("generating quick stats...")
		index = generate_quick_stats( fname, index )

		logger.info("generating measures data..."+  index)
		index = generate_measures_data( fname, index )

		logger.info("generating drgs data..." + index)
		index = generate_drgs_data( fname, index )
		
		logger.info("Done:", index)
		res.send("file:"+fname+" has been generated:"+index)
	}
};