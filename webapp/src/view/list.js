var BaseComponent = require('common/basecomponent');
var Vue = require('vue');

var View = BaseComponent.extend({
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