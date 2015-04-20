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
				this.startPage('index');
			},
			dbltap: function() {
				alert('rotate');
			}
		},
		created: function() {
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
	.dbtap {
		width: 100px;
		height: 100px;
		background-color: blue;
	}
</style>

<template>
	<h1>404 not found</h1>
	<input type="button" v-on="click: clickHandler()" value="goto /index" />
</template>