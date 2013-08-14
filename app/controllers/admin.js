var util	= require('util'),
	eyes	= require('eyes');
	
module.exports = {
	index: function(req, res) {
		var user = req.user;
		if( user.username != 'admin') {
			logger.info('Invalid user to access admin page:', user.username);
			return res.redirect('/')
		}
		
		res.render( 'admin/index.ejs', 
				{ 	layout: "layout.ejs",
				 	user: user
				});
	}
};