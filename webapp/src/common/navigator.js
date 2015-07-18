//require modules
var config = require('config');
var Vue = require('vue');

var pageHistory = [];
var pageCache = {};
var curPage, lastPage;

var setCurPage = function(page, idx) {
	if(curPage) lastPage = curPage;
	curPage = page;
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

window.onhashchange = function() {
	var route = getRouteFromHash();
	gotoRoute(route);
};

var getRouteFromHash = function() {
	var hash = location.hash;
	var reg = /#([^?]*)/;
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
		lastPage && lastPage.$options.pause && lastPage.$options.pause.call(page);
		page.$options.resume && page.$options.resume.call(page);
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
		lastPage && lastPage.$options.pause && lastPage.$options.pause.call(lastPage);
		page.$options.resume && page.$options.resume.call(page);
	};
	 if(route == 'register') {
		require.ensure([], function() {
			var Page = require('pages/register');
			ensureCb(Page);
		})
	}  else if(route == 'paper') {
		require.ensure([], function() {
			var Page = require('pages/paper');
			ensureCb(Page);
		})
	} else if (route== 'newUser' ){
		require.ensure([], function() {
			var Page = require('pages/newUser');
			ensureCb(Page);
		})
	} else if (route=='picupdate') {
		require.ensure([], function() {
			var Page = require('pages/picupdate');
			ensureCb(Page);
		})
	}else if (route=='accRegister') {
		require.ensure([], function() {
			var Page = require('pages/accRegister');
			ensureCb(Page);
		})
	}else if (route=='downloadAPP') {
		require.ensure([], function() {
			var Page = require('pages/downloadAPP');
			ensureCb(Page);
		})
	}else if (route=='confirmSubmit') {
		require.ensure([], function() {
			var Page = require('pages/confirmSubmit');
			ensureCb(Page);
		})
	}else if (route=='recruit') {
		require.ensure([], function() {
			var Page = require('pages/recruit');
			ensureCb(Page);
		})
	}else if (route=='examResult') {
		require.ensure([], function() {
			var Page = require('pages/examResult');
			ensureCb(Page);
		})
	}else if (route=='miuprivacy') {
		require.ensure([], function() {
			var Page = require('pages/miuprivacy');
			ensureCb(Page);
		})
	}else if (route=='aboutmiu') {
		require.ensure([], function() {
			var Page = require('pages/aboutmiu');
			ensureCb(Page);
		})
	}else if (route=='driverguide') {
		require.ensure([], function() {
			var Page = require('pages/driverguide');
			ensureCb(Page);
		})
	}else if (route=='guidedetails') {
		require.ensure([], function() {
			var Page = require('pages/guidedetails');
			ensureCb(Page);
		})
	}
	else {
		require.ensure([], function() {
			var Page = require('pages/notfound');
			ensureCb(Page);
		})
	} 
};

module.exports = {
	DEFAULT_ROUTE: 'newUser',
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