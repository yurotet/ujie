<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');

	var View = BasePage.extend({
		title: '出错了',
		
		methods: {
			
		},
		created: function() {
		},
		
	});

	module.exports = View;
</script>

<style>
	.regHeader , .cntContainer{
		text-align: center;
	}
	.cntContainer h3 {
		margin:25px;
	}
	.cntContainer p {
		font-size: 16px;
		margin:30px;
	}
</style>

<template>
	<div class="regHeader">
		<img src="logo.png"></img>
	</div>

	<div class='cntContainer'>		
		<p>请确保您的网络连接通畅，稍后再试！</p>			
	</div>	
</template>