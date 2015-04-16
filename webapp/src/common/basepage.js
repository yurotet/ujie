var nav = require('common/navigator');
var Vue = require('vue');
var $Class = require('oo-class');

var M = Vue.extend({
});

$Class.mix(M.prototype, {
	name: 'BagePage',
	// startMode: "singleton",
	startMode: "newinstance",
	startPage: function(route) {
		nav.goTo(route);
	},
	startPageForResult: function(route, cb) {
	},
	back: function() {
		nav.back();
	}
});

module.exports = M;