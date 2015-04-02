var BasePage = require('common/basepage');
var Vue = require('vue');

var View = BasePage.extend({
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