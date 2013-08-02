var express 		= require('express'),
	util			= require('util'),
	partials 		= require('express-partials'),
	assert			= require('assert'),
	fs				= require('fs'),
	path			= require('path'),
	redis 			= require("redis/index"),
	debug 			= require('debug')('server'),
	engines			= require('consolidate'),
	passport 		= require('passport'),
	BasicStrategy 	= require('passport-http').BasicStrategy,
	RedisStore 		= require('connect-redis')(express),
	ejs				= require('ejs');
		
	exports.boot = function(app){
	   bootApplication(app)
	}

	// load env settings
		
	// not using Nodejitsu
	//app.jitsu = JSON.parse(fs.readFileSync("./jitsu.env"));

	// The port that this express app will listen on
	debug("app_port:"+app_port)
	
	var port, hostBaseUrl
	
	if( app.settings.env === 'development') {
		port 			= app_port;
		hostBaseUrl 	= 'http://localhost:' + port;
	} else {
		hostBaseUrl 	= app.config.HOSTBASEURL;
		port 			= app.config.PORT;		
	}

	app.set('hostBaseUrl', hostBaseUrl)
	app.set('port', port)

	//var redisHost 		= app.jitsu.REDIS_HOST;
	//var redisPort 		= app.jitsu.REDIS_PORT;
	//var redisAuth 		= app.jitsu.REDIS_AUTH;

	//debug('hostBaseUrl:'+hostBaseUrl)
	//debug('apiBaseUrl:'+apiBaseUrl)
	//debug('port:'+port)

	//assert(redisHost, 	"set REDIS_HOST in your ENV")
	//assert(redisPort, 	"set REDIS_PORT in your ENV")
	//assert(redisAuth, 	"set REDIS_AUTH in your ENV")
		
	// Pick a secret to secure your session storage
	var sessionSecret = 'SCRC-PGC-2012-07';

// =========================================
// settings

	
// ===========================
// App settings and middleware
function bootApplication(app) {

	// load config
	app.config = JSON.parse(fs.readFileSync("./config/config.yaml"));

	
	// define a custom res.message() method
	// which stores messages in the session
	app.response.message = function(msg){
	  // reference `req.session` via the `this.req` reference
	  var sess = this.req.session;
	  // simply add the msg to an array for later
	  sess.messages = sess.messages || [];
	  sess.messages.push(msg);
	  return this;
	};
	
	// serve static files
	app.use(express.static(__dirname + '/public'));
	app.use(partials());

	app.set('views', __dirname + '/app/views')
	app.set('helpers', __dirname + '/app/helpers/')
   	app.set('view engine', 'ejs');
	app.engine('html', engines.ejs);
	app.engine('jade', engines.jade)
	
 	app.set('client_side_layout', __dirname + '/app/views/layout.ejs')

	app.set('view options', { layout: 'layout.ejs' })

	// cookieParser should be above session
	app.use(express.cookieParser())

	// bodyParser should be above methodOverride
	app.use(express.bodyParser())
	app.use(express.methodOverride())

	// Configure the database
	// Needs this to store sessions across servers
	
	//if( app.settings.env == 'production') {
		// jitsu databases create redis rip2
		// jitsu databases list 
		
	//	var redisUrl 	= app.jitsu.REDIS_HOST,
	//    	redisName 	= app.jitsu.REDIS_NAME,
	//    	redisAuth 	= app.jitsu.REDIS_AUTH,
	//		redisPort	= app.jitsu.REDIS_PORT;

	//	debug(redisUrl, redisPort, redisAuth, redisName)

	//	app.set('redisHost', 	redisUrl.hostname);
	//	app.set('redisPort', 	redisUrl.port);
	//	app.set('redisDb', 		redisName);
	//	app.set('redisPass', 	redisAuth); 

	//app.db				    = redis.createClient(redisPort, redisUrl);
		app.db				    = redis.createClient();
		//app.db.auth(redisAuth, function(err) {
		//	if( err ) throw err;
		//	debug("redis connected")
		//});
		app.db.debugMode 	= true; 
		app.db.on("error", function (err) {
		    debug("Production Redis Database Error " + err);
		});
			
		app.use(express.session({
		  secret: sessionSecret,
		  cookie: { maxAge: new Date(Date.now() + 360000)}, //1 Hour
		  store: new RedisStore({client: app.db})
		}))

	//var mysql      = require('mysql');
	//var connection = mysql.createConnection({
	//	host     : 'geobpms.geobliki.com',
	//	user     : 'cappelaere',
	//	password : '1cappelaere2',
	//	database : 'mysql',
	//	debug: true,
	//	//insecureAuth: true
	//});
	//connection.connect();
		
	//} else {
	//	debug("* Connecting to localhost redis...");
	//	app.db			 = redis.createClient();
	//	app.db.on("error", function (err) {
	//	    debug("Local Redis Database Error " + err);
	//	});
	//	app.use(express.session({
	//	  secret: sessionSecret,
	//	  cookie: { maxAge: new Date(Date.now() + 360000)}, //1 Hour
	//	  store: new RedisStore()
	//	}))
	//}
	var pg = require('pg'); 
	var conString = "postgres://postgres:postgres@localhost:5432/scrc";
	app.client = new pg.Client(conString);
	app.client.connect(function(err) {
	  if(err) {
	    return console.error('could not connect to postgres', err);
	  }
	  app.client.query('SELECT NOW() AS "theTime"', function(err, result) {
	    if(err) {
	      return console.error('error running query', err);
	    }
	    console.log("postgres time:", result.rows[0].theTime);
	    //output: Tue Jan 15 2013 19:12:47 GMT-600 (CST)
	    //
	  });
	});
	
	app.use(express.favicon())
	
	function findByUsername(username, fn) {
		var query = "SELECT * from users where username='"+username+"'"
		app.client.query(query, function(err, result) {
			if( err == null ) {
				return fn(null, result.rows[0] )
			}
			return fn(err, result)
	  	})
	}
	

	passport.use(new BasicStrategy({
	  },
	  function(username, password, done) {
	    // asynchronous verification, for effect...
	    process.nextTick(function () {

	      // Find the user by username. If there is no user with the given
	      // username, or the password is not correct, set the user to `false` to
	      // indicate failure. Otherwise, return the authenticated `user`.
	      findByUsername(username, function(err, user) {
	        if (err) { return done(err); }
	        if (!user) { return done(null, false); }
	        if (user.password != password) { return done(null, false); }
	        return done(null, user);
	      })
	    });
	  }
	));

	
	app.use(passport.initialize());
	// routes should be at the last
	app.use(app.router)
	
	// expose the "messages" local variable when views are rendered
	app.use(function(req, res, next){
	  var msgs = req.session.messages || [];

	  // expose "messages" local variable
	  res.locals.messages = msgs;

	  // expose "hasMessages"
	  res.locals.hasMessages = !! msgs.length;

	  /* This is equivalent:
	   res.locals({
	     messages: msgs,
	     hasMessages: !! msgs.length
	   });
	  */

	  // empty or "flush" the messages so they
	  // don't build up
	  req.session.messages = [];
	  next();
	});
	
	// Error Handling
	app.use(function(err, req, res, next){
	  // treat as 404
	  if (~err.message.indexOf('not found')) return next()

	  // log it
	  console.error(err.stack)

	  // error page
	  res.status(500).render('500')
	})

	// assume 404 since no middleware responded
	app.use(function(req, res, next){
	  res.status(404).render('404', { url: req.originalUrl })
	})
}
 