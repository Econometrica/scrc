var util	= require('util'),
	eyes	= require('eyes'),
	async	= require('async'),
	fs		= require('fs');

//
// Retrieve specific site for id
//
function getSite( id, fn ) {
	var query = "SELECT * from sites where id="+id
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

//
// Retrieve all DRGS
//
function getDrgs( fn ) {
	var query = "SELECT * from drgs order by id"
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve all measures
//
function getMeasures( fn ) {
	var query = "SELECT * from measures"
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve all subpopulations
//
function getSubpopulations( fn ) {
	var query = "SELECT * from subpopulations"
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

//
// Retrieve specific measure
//
function getMeasure(id, fn ) {
	var query = "SELECT * from measures where id="+id
	app.client.query(query, function(err, result) {
		fn(err, result.rows[0])
	})
}

//
// Retrieve all domains
//
function getDomains( fn ) {
	var query = "SELECT * from domains order by id "
	app.client.query(query, function(err, result) {
		fn(err, result.rows)
	})
}

module.exports = {
	transitions: function(req, res) {
		var id 		= req.params['id']
		var user 	= req.user
		
		console.log('transitions', id)
		getSite(id, function(err, result ) {
			res.render( 'aspect/transitions.ejs', {layout: 'layout.ejs', site: result});	
		})
	},
	
	measure: function(req,res) {
		var m_id 	= req.params['id']
		var s_id	= req.query['site']
		var user 	= req.user
		console.log('measure ', m_id, ' for site:', s_id)
		getSite(s_id, function(err, site ) {
			getMeasure(m_id, function(err, measure ) {
				res.render( 'aspect/measure.ejs', 
					{	layout: 'layout.ejs', 
						site: 	site,
						measure: measure
					});	
			})
		})
	},
	
	// Users picks a measure
	measures: function(req,res) {
		var id 		= req.params['id']
		var user 	= req.user
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
		eyes.inspect(req.body, "body")
		var id 		= req.body['site']
		var drg 	= req.body['drg']
		var subpop 	= req.body['subpop']
		
		var arr		= drg.split(' ')
		var drg_id	= arr[0]
		
		async.parallel([
			function(callback) {
				getSite(id, function(err, result ) {					
					callback(null, result)
				})
			}
		], function(err, results) {
			res.render( 'aspect/drg.ejs', 
				{	layout: 'layout.ejs', 
					drg: 	drg,
					drg_id: drg_id,
					subpop:	subpop,
					site: 	results[0]
				});	
		})
	},
	
	// select DRG form
	drgs: function(req,res) {
		var id 		= req.params['id']
		var user 	= req.user
		console.log('drgs', id)
		
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
	}
}
