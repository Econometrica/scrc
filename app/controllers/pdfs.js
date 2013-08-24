var util	= require('util'),
	eyes	= require('eyes'),
	asyncjs	= require('asyncjs'),
	fs		= require('fs'),
	path	= require('path');
	
var dir = __dirname +"../../../public/reports"

module.exports = {
	index: function(req, res) {
		var udir = path.join(dir)
		var user = req.user;
		if( user.site_id != 0) {
			udir = path.join(udir, "site"+user.site_id)
		}

		var filter = function(file) {
	        return file.name !== ".DS_Store"
	    }
		var files = []
		//console.log("pdfs dir", dir)

	    asyncjs.walkfiles(udir, filter, true)
	        .each(function(file) {
				var stats = fs.statSync(file.path)
				if( !stats.isDirectory() ) {
					var d = path.join(dir,"/")
					files.push(file.path.replace(d,""))
				}
	            //console.log(file.path)
	        })
	        .end( function() {
				res.render("pdfs/index", 
					{	layout: true,
						user: user,
						files: files
					})
			})
	},
	download: function(req, res) {
		var id 		= req.params['id']
		var year 	= req.params['year']
		var site 	= req.params['site']
		var fname	= path.join(dir, site, year, id)
		
	  	res.download(fname); // Set disposition and send it.
	}
};