<script>
	var BaseComponent = require('common/basecomponent');
	var Vue = require('vue');

	var View = BaseComponent.extend({
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

	module.exports = View;
</script>

<style>
	.red {
		color: #f00;
	}
</style>

<template>
	<div class="red">index page {{count}}</div>
</template>