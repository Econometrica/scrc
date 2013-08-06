var util 	= require('util');
var eyes	= require('eyes');

module.exports = {
  
	// login
	index: function(req, res) {       
		var requested_url = req.query['requested_url'];
		console.log("login session:", util.inspect(req.session));
		console.log("requested_url:", requested_url);
		
		if( req.session ) {
			console.log("setting requested_url")
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
		console.log("logged out!!!");
		eyes.inspect(res.headers, 'headers')
		req.logOut();
		//res.session.destroy(); 
		delete res.session;
		if( res.headers && res.headers['authorization'] ) delete res.headers['authorization'];
		if( res.headers && res.headers['cookie'] ) delete res.headers['cookie'];
		res.clearCookie('userid');
		res.clearCookie('user');
		res.redirect('/')
	}
};