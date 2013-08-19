var util 	= require('util');
var eyes	= require('eyes');
var crypto 	= require('crypto');
var und		= require('underscore')

make_passwd = function(n, a) {
  var index = (Math.random() * (a.length - 1)).toFixed(0);
  return n > 0 ? a[index] + make_passwd(n - 1, a) : '';
};

module.exports = {
	list: function(req, res) {
		var user = req.user
		//eyes.inspect(user, "user")
		var query = "SELECT * from users"
		app.client.query(query, function(err, result) {
			var users = result.rows
			if( user.site_id != 0 ) return res.redirect("/")
			
			//eyes.inspect(users, "users")
			res.render('users/list.ejs', 
				{	layout:true,
					user: user,
					users: und.sortBy(users, function(e) { return e.username })
				})
		})
	},
	
	create: function(req, res) {
		var user 		= req.user
		var username 	= req.body.username
		var email		= req.body.email
		var site_id		= req.body.site_id

		if( user.site_id != 0 ) return res.redirect("/")
		
		var password 	= make_passwd(8, 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890');
		var md5 		= crypto.createHash('md5').update(password+app.secret).digest("hex");
		var insert 		= "insert into users (username, email, site_id, md5 ) VALUES("
		insert 			+= "'" + username + "',"	
		insert 			+= "'" + email + "',"	
		insert 			+=  site_id + ","	
		insert 			+= "'" + md5 + "')"	
		
		logger.info(insert)
		
		app.client.query(insert, function(err, result) {
			if( err === null ) {
				// send new password to email address
				var text = "A new account has been created for you at " + app.config.HOSTBASEURL + "\n"
				text += " username: " + username + "\n"
				text += " password: " + password + "\n\n"
				text += "If you have any problem, contact:"+ app.config.contact_email + "\n\n"
				text += "Thank you."
				
				app.sendgrid.send({
				  to: [email, app.config.contact_email],
				  from: app.config.contact_email,
				  subject: 'SCRS New User',
				  text: text
				}, function(success, message) {
					if (!success) {
				    	logger.info(message);
					} 
				});
				res.redirect('/users')
			} else {
				res.send("Err updating record:"+err)
			}
		})	
	},
	
	submit: function(req, res) {
		var user 	= req.user
		var submit	= req.body['submit']
		var email	= req.body.email
		var site_id	= req.body.site_id
		
		if( submit == 'Submit') {
			var md5 = null;
			var password	= req.body.password
			if( password ) {
				md5 		= crypto.createHash('md5').update(password+app.secret).digest("hex");
			}
		
			var update = "Update users"
			update += " SET username='"+ req.body.username +"',"
			update += " email='"+ req.body.email +"' "
		
			if( site_id ) update += ", site_id='"+ req.body.site_id +"' "
			
			if( md5 ) update += ", md5='"+ md5 +"' "
			
			update += " WHERE id="+req.body.id
			console.log(update)
			app.client.query(update, function(err, result) {
				if( err === null ) {
					res.redirect('/users')
				} else {
					logger.error("Error updating:"+err)
				}
			})
		} 
	},
	
	update: function(req, res) {
		var user = req.user
		var id 	 = req.params['id']
		var query = "SELECT * from users where id="+id
		app.client.query(query, function(err, result) {
			console.log(err)
			var site_user = result.rows[0]
			res.render('users/update.ejs', 
				{	layout:true,
					user: user,
					site_user: site_user
				})
		})
	},

	delete: function(req, res) {
		var user = req.user
		
		if( user.site_id != 0 ) return res.redirect("/")
		
		var id = req.params['id']
		var query = "DELETE from users where id="+id
		app.client.query(query, function(err, result) {
			console.log("user "+id+" deleted", err, result)
			res.send("ok")
		})
	},
	
	form: function(req, res) {
		console.log("Form for new user...")
		var user = req.user
		res.render('users/form.ejs', 
			{	layout: true,
				user: 	user
			})
	}
};