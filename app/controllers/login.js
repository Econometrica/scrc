var util 	= require('util');
var eyes	= require('eyes');
var crypto = require('crypto');

make_passwd = function(n, a) {
  var index = (Math.random() * (a.length - 1)).toFixed(0);
  return n > 0 ? a[index] + make_passwd(n - 1, a) : '';
};

module.exports = {
  
	// login
	index: function(req, res) {       
		console.log("login")
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
	forgot: function(req, res ) {
		console.log("forgot")
		res.render('login/forgot.ejs', {layout: false, config: app.config });
	},
	forget: function(req, res ) {
		console.log("forget")
		res.render('login/forget.ejs', {layout: false, config: app.config });
	},
	reset: function(req,res){
		var email = req.body['email']
		
		var query = "SELECT * from users where email='"+email+"'"
		app.client.query(query, function(err, result) {
			if( err == null && result.rows[0]) {
				var password = make_passwd(8, 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890');
				var md5 = crypto.createHash('md5').update(password+app.secret).digest("hex");
			
				var update = "UPDATE users SET md5='"+ md5+"' where email='"+email+"';"
				log.info(update)
				app.client.query(update, function(err, result) {
					log.info("Update:", err)
					if( err === null ) {
						var text="Your SCRS password has been reset to: " + password + "\n"
						text += "Please login to " + app.config.HOSTBASEURL + "as: "+ username + " and change your password\n"
						text += "Please contact " + app.config.contact_email + " if you have any problem\n\n"
						text += "Thank you."
						
						app.sendgrid.send({
						  to: [email, app.config.contact_email],
						  from: app.config.contact_email,
						  subject: 'SCRS Password Reset',
						  text: text
						}, function(success, message) {
							if (!success) {
						    	logger.info(message);
							} 
						});
						res.send('New password sent...'+ email+" "+password+" "+md5)
					} else {
						res.send("Err updating record:"+err)
					}
				})
			} else {
				res.send('Sorry! email not found in our database...' + email)
			}
		})
	},
	// logout
	logout: function(req, res) {
		logger.info("logged out!!!");
		req.logOut();
		res.redirect('/')
	}
};