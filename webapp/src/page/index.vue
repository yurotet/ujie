<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');

	var View = BasePage.extend({
		title: 'index',
		data: function() {
			return {
				count: 0
			};
		},
		methods: {
			clickHandler: function() {
				this.startPage('/list');							
			}
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
	<input type="button" v-on="click: clickHandler()" value="goto new /list" />
</template>