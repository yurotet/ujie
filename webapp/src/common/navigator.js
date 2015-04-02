//require modules
var Vue = require('vue');

var viewport = new Vue({
	el: '#viewport-cnt',
	data: {
		current: null
	}
});

var _routeCb = function(route) {
	return function() {
		var cmp, cmpId;
		if(route == '/' || route == '/index') {
			require.ensure([], function() {
				cmpId = 'view/index';
				cmp = require('view/index');
				viewport.current = cmpId;
			});
		} else if(route == '/list') {
			require.ensure([], function() {
				cmpId = 'view/list'
				cmp = require('view/list');
				viewport.current = cmpId;
			});
		}
	};
};

var routes = {
	'/index': _routeCb('/index'),
	'/list': _routeCb('/list')
};

var router = Router(routes)
.configure({
	pushState: true
}).init();

module.exports = {
	forward: function(route) {
		router.setRoute(route);
	},
	back: function() {
		history.back();
	}
};