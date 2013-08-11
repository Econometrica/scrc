/**
 * Module dependencies.
 */

var express 		= require('express'),
	path			= require('path'),
	util			= require('util'),
	fs				= require('fs'),
  	debug 			= require('debug')('server'),
	passport 		= require('passport'),
	Localtrategy 	= require('passport-local').Strategy,
	//BasicStrategy 	= require('passport-http').BasicStrategy,
	home			= require('./app/controllers/home'),
	login			= require('./app/controllers/login'),
	aspect			= require('./app/controllers/aspect'),
	generator		= require('./app/controllers/generator'),
	test			= require('./app/controllers/test');

		
var app = module.exports = express();

global.app 			= app;
app.root 			= process.cwd();

// we need to configure environment
console.log(util.inspect(app.settings));

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


function auth(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/login')
}

// Home page -> app
app.get('/', 									auth, home.index);
app.get('/sites.geojson',						auth, home.sites);
app.get('/site/transitions/:id',				auth, aspect.transitions);
app.get('/site/transitions/:site_id/:dept_id',	auth, aspect.transitions_department);

//app.get('/site/transitions/:site_id/:dept_id',	aspect.transitions_department);

app.get('/site/measures/:id',					auth, aspect.measures);
app.get('/site/measure/:id',					auth, aspect.measure);
app.get('/site/measure/:mid/:sid',				auth, aspect.site_measure);
app.get('/site/drgs/:id',						auth, aspect.drgs);
app.post('/site/drg',							auth, aspect.drg);
app.get('/site/sdsm',							auth, aspect.sdsm);

app.get('/site/bsdmp/:site_id/:drg_id/:m_id/:pop_id/:year/:quarter',
			auth, aspect.benchmark_sdmp);

app.get('/site/benchmarks/:id',					auth, aspect.benchmarks);
app.post('/site/benchmark',						auth, aspect.benchmark);

app.get('/contact', 							home.contact);
app.get('/about', 								home.about);

app.get('/login', 								login.index);

app.post('/login', function(req, res, next) {
  passport.authenticate('local', function(err, user, info) {
    if (err) { return next(err) }
    if (!user) {
      req.session.messages = [info.message];
      return res.redirect('/login')
    }
    req.logIn(user, function(err) {
      if (err) { return next(err); }
      return res.redirect('/');
    });
  })(req, res, next);
});

app.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

app.get('/generator',							auth, generator.index);
app.get('/test',								auth, test.index);


// ===========================================================
// port set based on NODE_ENV settings (production, development or test)
debug("trying to start on port:"+ app.get('port'));

if (!module.parent) {
	app.listen(app.get('port'));
	
	console.log( app.config.application+' started on port:'+app.get('port'));
}