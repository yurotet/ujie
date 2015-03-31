define(function(require, exports, module) {
	var BasePage = require('common/basepage');
	module.exports = BasePage.extend({
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
});