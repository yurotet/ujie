//require modules
var config = require('config');
var Vue = require('vue');

var pageHistory = [];
var pageCache = {};
var curPageIdx;
var lastPageIdx;

var setCurPage = function(page, idx) {
	lastPageIdx = curPageIdx;
	curPageIdx = idx != undefined ? idx : pageHistory.indexOf(page);
	document.title = page.$options.title;
	$(page.$el).show().siblings().hide();
};

var findPage = function(route) {
	return pageCache[route];
	// for(var i = 0; i < pageHistory.length; ++i) {
	// 	var page = pageHistory[i];
	// 	if(page.route == route) {
	// 		return page;
	// 	}
	// }
};

var clearRemainingPages = function(fromPageIdx) {
	var removed = pageHistory.splice(fromPageIdx + 1, pageHistory.length - fromPageIdx - 1);
	for(var i = 0; i < removed.length; ++i) {
		var p = removed[i];
		$(p.$el).remove();
	}
};

window.onpopstate = function() {
	if(config.isPushState) {
		console.log(pageHistory);
		var state = history.state;
		var page = pageHistory[state.pageIdx];
		setCurPage(page);

		//back oper
		if(curPageIdx < lastPageIdx) {
			console.log('back');
		} else {
			console.log('forward');
		//forward oper
		}
	}
};

window.onhashchange = function() {
	var route = getRouteFromHash();
	gotoRoute(route);
};

var getRouteFromHash = function() {
	var hash = location.hash;
	var reg = /#(.*)/;
	var result = hash.match(reg);
	if(result && result.length == 2) {
		route = result[1];
		return route;
	}
};

var buildPage = function(Page, route) {
	var $pageEl = $('<div class="card" style="display: none;"/>');
	var page = new Page({
		el: $pageEl[0],
		route: route
	});
	return page;
};

var addPage = function(page) {
	pageHistory.push(page);
	$('#viewport').append(page.$el);
};

var gotoRoute = function(route) {
	var page = findPage(route);
	if(page) {
		setCurPage(page);
		return;
	}
	var ensureCb = function(Page) {
		// if(config.isPushState) {
		// 	var pageIdx = pageHistory.length;
		// 	//如果是第一个页面，就replace当前的state
		// 	var replace = pageHistory.length == 0;
		// 	history[replace ? 'replaceState' : 'pushState']({
		// 		route: route, // '/webapp/ ' + 'index'
		// 		pageIdx: pageIdx
		// 	}, '', config.contentBase + route);
		// 	//删除后续页面
		// 	clearRemainingPages(pageIdx);
		// }
			
		var page = buildPage(Page, route);
		pageCache[route] = page;
		addPage(page);
		setCurPage(page);
	};
	if(route == 'index') {
		require.ensure([], function() {
			var Page = require('pages/index');
			ensureCb(Page);
		});
	} else if(route == 'list') {
		require.ensure([], function() {
			var Page = require('pages/list');
			ensureCb(Page);
		});
	} else if(route == 'driverreg') {
		require.ensure([], function() {
			var Page = require('pages/driverreg');
			ensureCb(Page);
		})
	} else if(route == 'register') {
		require.ensure([], function() {
			var Page = require('pages/register');
			ensureCb(Page);
		})
	} else {
		require.ensure([], function() {
			var Page = require('pages/notfound');
			ensureCb(Page);
		})
	}
};

module.exports = {
	DEFAULT_ROUTE: 'index',
	_inited: false,
	init: function() {
		if(!this._inited) {
			var route;
			route = getRouteFromHash();
			if(!route) route = this.DEFAULT_ROUTE;
			gotoRoute(route);
			this._inited = true;
		}
	},
	goTo: function(route) {
		//去除前置与后置的斜杠///
		route = route.replace(/(^\/+)|(\/+$)/g, '');
		location.hash = route;
	},
	back: function() {
		history.back();
	}
};