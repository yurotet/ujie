var BaseComponent = require('common/basecomponent');
var Vue = require('vue');

var View = BaseComponent.extend({
	template: "index page {{count}}",

	data: function() {
		return {
			count: 0
		};
	},
	created: function() {
		console.log('index created');
		setInterval(function() {
			this.count++;
		}.bind(this), 500);
	},
	ready: function() {
		console.log('index ready');
	},
	attached: function() {
		console.log('index attached');
	},
	detached: function() {
		console.log('index detached');
	}
});

Vue.component('view/index', View);

module.exports = View;