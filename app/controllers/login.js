var util 	= require('util');
var eyes	= require('eyes');

module.exports = {
  
	// login
	index: function(req, res) {       
		var requested_url = req.query['requested_url'];
		logger.info("login session:", util.inspect(req.session));
		logger.info("requested_url:", requested_url);
		
		if( req.session ) {
			logger.info("setting requested_url")
			req.session.requested_url = requested_url;
		} else {
			//req.session = {
			//	requested_url: requested_url
			//}
		}
		
		//@TODO fix authorizationlink to go back to requested_url
		res.render( 'login/index.ejs', {layout: false, config: app.config});				
	},
	// logout
	logout: function(req, res) {
		logger.info("logged out!!!");
		req.logOut();
		
		res.redirect('/')
	}
};