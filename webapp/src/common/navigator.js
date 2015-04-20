//require modules
var Vue = require('vue');
var $Class = require('oo-class');

var pageHistory = [];
var curPageIdx;
var lastPageIdx;

var setCurPage = function(page, idx) {
	lastPageIdx = curPageIdx;
	curPageIdx = idx != undefined ? idx : pageHistory.indexOf(page);
	document.title = page.$options.title;
	$(page.$el).show().siblings().hide();
};

var findPage = function(route) {
	for(var i = 0; i < pageHistory.length; ++i) {
		var page = pageHistory[i];
		if(page.route == route) {
			return page;
		}
	}
};

var clearRemainingPages = function(fromPageIdx) {
	var removed = pageHistory.splice(fromPageIdx + 1, pageHistory.length - fromPageIdx - 1);
	for(var i = 0; i < removed.length; ++i) {
		var p = removed[i];
		$(p.$el).remove();
	}
};

window.onpopstate = function() {
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
};

var gotoRoute = function(route, replace) {
	var page = findPage(route);
	if(page) {
		if(!page.startMode || page.startMode == 'singleton') {
			pageHistory.push(page);
			var pageIdx = pageHistory.length - 1;
			history[replace ? 'replaceState' : 'pushState']({
				route: route,
				pageIdx: pageIdx
			}, '', route);
			setCurPage(page);
			return;
		}
	}
	var ensureCb = function(Page) {
		var $pageEl = $('<div class="page" style="display: none;"/>');
		var page = new Page({
			el: $pageEl[0],
			route: route
		});
		//删除后续页面
		clearRemainingPages(curPageIdx);
		pageHistory.push(page);
		var pageIdx = pageHistory.length - 1;
		history[replace ? 'replaceState' : 'pushState']({
			route: route,
			pageIdx: pageIdx
		}, '', route);
		$('#viewport').append(page.$el);
		setCurPage(page);
	};
	if(route == '/index') {
		require.ensure([], function() {
			var Page = require('pages/index');
			ensureCb(Page);
		});
	} else if(route == '/list') {
		require.ensure([], function() {
			var Page = require('pages/list');
			ensureCb(Page);
		})
	}
};

module.exports = {
	DEFAULT_ROUTE: '/index',
	_inited: false,
	init: function() {
		if(!this._inited) {
			var route = location.pathname;
			if(!route || route == '/') route = this.DEFAULT_ROUTE;
			gotoRoute(route, true);
			this._inited = true;
		}
	},
	goTo: function(route) {
		gotoRoute(route);
	},
	back: function() {
		history.back();
	}
};