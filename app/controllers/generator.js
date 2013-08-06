var util	= require('util'),
	eyes	= require('eyes'),
	async	= require('async'),
	fs		= require('fs');

	var sites 		= [1,2,3,
					10,11,12,13,14,15,16,17,18,19,
					20,21,22,23,24,25,26,27,28,29,
					30,31,32,33 ]
	
	var drgs 		= [ 163, 238, 469 ]
	var measures	= [4, 	5, 	6, 	7, 	8, 9 , 	10]
	var max			= [10, 20, 200, 20, 30, 10, 100 ]
	var subpop		= [1,2,3]
	var quarters	= [1,2,3,4]
	
	var years		= [2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012]

	module.exports = {
		 
	// generate simulated data
	index: function(req, res) {
		var index 	= 1
		var fname	= '/Users/patrice/Development/scrc/data.txt'
		var fd = fs.openSync( fname, "w")
		
		for( var s in sites ) {
			for( var d in drgs  ) {
				for( var m in measures ) {
					for( var y in years ) {
						for( var q in quarters ) {
							var site_id 	= sites[s]
							var drg_id		= drgs[d]
							var measure_id	= measures[m]
							var year		= years[y]
							var  quarter	= quarters[q]
							var val 		= Math.floor((Math.random()* max[m])+1); 
							var subpop 		= Math.floor((Math.random()* 3 )+1);
							var ub 			= val + Math.floor((Math.random() * 3 )+1); 
							var lb 			= val - Math.floor((Math.random() * 3 )+1); 
							
							if( lb<0 ) 		lb = 0
							
							var str = index +"," + site_id + "," + drg_id + "," + subpop + ","
							str += measure_id + "," + year + "," + quarter + "," + val + ","
							str += ub + "," + lb + "\n"
							
							if( index === 1 ) {
								fs.writeFileSync(fname, str)
							} else {
								fs.appendFileSync(fname, str)
							}
							index += 1
						}
					}
				}
			}
		}
		res.send("file:"+fname+" has been generated")
	}
};