var Vue = require('vue');
var nav = require('common/navigator');

// var pageCache = {};
// function getPage(route, cb) {
// 	var Page = pageCache[route];
// 	if(Page) {
// 		cb(Page);
// 	} else {
// 		var Page;
// 		if(route == 'view/index') {
// 			require.ensure([], function() {
// 				Page = require('view/index');
// 				Vue.component(_getPageId(route), Page);
// 				cb(Page);
// 			});
// 		} else if(route == 'view/list') {
// 			require.ensure([], function() {
// 				Page = require('view/list');
// 				Vue.component(_getPageId(route), Page);
// 				cb(Page);
// 			});
// 		}
// 	}
// }

// function _getPageId(route) {
// 	return "viewport-" + route;
// }

// viewport = new Vue({
// 	el: '#viewport-cnt',
// 	data: {
// 		current: null
// 	}
// });

$('input').on('click', function() {
	var route = $(this).val();
	nav.forward(route);
});