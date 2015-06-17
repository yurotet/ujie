webpackJsonp([2],{

/***/ 71:
/***/ function(module, exports, __webpack_require__) {

	var BaseComponent = __webpack_require__(72);
	var Vue = __webpack_require__(4);

	var View = BaseComponent.extend({
		title: 'list',
		template: "list page",
		created: function() {
			console.log('list created');
		},
		attached: function() {
			console.log('list attached');
		},
		detached: function() {
			console.log('list detached');
		}
	});

	module.exports = View;

	Vue.component('view/list', View);

/***/ },

/***/ 72:
/***/ function(module, exports, __webpack_require__) {

	var Vue = __webpack_require__(4);
	var M = Vue.extend({
		onCreate: function() {

		},
		onResume: function() {

		},
		onPause: function() {

		}
	});

	module.exports = M;

/***/ }

});