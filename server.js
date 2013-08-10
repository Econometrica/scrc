/**
 * Module dependencies.
 */

var express 		= require('express'),
	path			= require('path'),
	util			= require('util'),
	fs				= require('fs'),
  	debug 			= require('debug')('server'),
	passport 		= require('passport'),
	BasicStrategy 	= require('passport-http').BasicStrategy,
	home			= require('./app/controllers/home'),
	login			= require('./app/controllers/login'),
	aspect			= require('./app/controllers/aspect'),
	generator		= require('./app/controllers/generator'),
	test			= require('./app/controllers/test');

		
var app = module.exports = express();

global.app 			= app;
app.root 			= process.cwd();

// we need to configure environment
debug(util.inspect(app.settings));

var mainEnv 	= app.root + '/config/environment'+'.js';
var supportEnv 	= app.root + '/config/environments/' + app.settings.env+'.js';
require(mainEnv)
require(supportEnv)

// load settings
require('./settings').boot(app)  



// load controllers
require('./lib/boot')(app, { verbose: !module.parent });


// =========================================
// ROUTING
//

// Access Control Function
function restrict(req, res, next) {
 	if( req.session ) {
		next();
		return;
  	}
  	// Failed... login
	console.log('Sorry...restricted!')
	if( !req.session) console.log('Sorry...no session!')

    res.format({
		html: function(req, res) {
			var redirect_to		= '/login?requested_url='+req.url;
			console.log("unauthorized! redirect to:"+redirect_to);
		    res.redirect(redirect_to, 302);
		},
		json: function() {
			var headers = {
				'Status': 			"Unauthorized",
			}
			res.send("Unauthorized", headers, 401);
		}
	})
}

// Home page -> app
app.get('/', 									passport.authenticate('basic', { session: false }), home.index);
app.get('/sites.geojson',						passport.authenticate('basic', { session: false }), home.sites);
app.get('/site/transitions/:id',				passport.authenticate('basic', { session: false }), aspect.transitions);
app.get('/site/transitions/:site_id/:dept_id',	passport.authenticate('basic', { session: false }), aspect.transitions_department);

//app.get('/site/transitions/:site_id/:dept_id',	aspect.transitions_department);

app.get('/site/measures/:id',					passport.authenticate('basic', { session: false }), aspect.measures);
app.get('/site/measure/:id',					passport.authenticate('basic', { session: false }), aspect.measure);
app.get('/site/measure/:mid/:sid',				passport.authenticate('basic', { session: false }), aspect.site_measure);
app.get('/site/drgs/:id',						passport.authenticate('basic', { session: false }), aspect.drgs);
app.post('/site/drg',							passport.authenticate('basic', { session: false }), aspect.drg);
app.get('/site/sdsm',							passport.authenticate('basic', { session: false }), aspect.sdsm);

app.get('/site/bsdmp/:site_id/:drg_id/:m_id/:pop_id/:year/:quarter',
			passport.authenticate('basic', { session: false }), aspect.benchmark_sdmp);

app.get('/site/benchmarks/:id',					passport.authenticate('basic', { session: false }), aspect.benchmarks);
app.post('/site/benchmark',						passport.authenticate('basic', { session: false }), aspect.benchmark);

app.get('/contact', 							home.contact);
app.get('/about', 								home.about);

app.get('/login', 								login.index);
app.get('/logout', 								login.logout);

app.get('/generator',							generator.index);
app.get('/test',								test.index);


// ===========================================================
// port set based on NODE_ENV settings (production, development or test)
debug("trying to start on port:"+ app.get('port'));

if (!module.parent) {
	app.listen(app.get('port'));
	
	console.log( app.config.application+' started on port:'+app.get('port'));
}