var util 		= require('util');
var fs	 		= require('fs');
var path		= require('path');
var debug		= require('debug')('tests');

module.exports = {
	// Test
	index: function(req, res) {       
		var user=req.user;
		res.render("help/help", {layout: true, user:user})
	},
}; 