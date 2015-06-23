<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');

	var View = BasePage.extend({
		title: '下载APP',
		
		methods: {
			
		},
		created: function() {

		},
		resume:function() {

		}
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
		margin:40px;
	}
</style>

<template>
	<div class="regHeader">
		<img src="logo.png"></img>
	</div>

	<div class='cntContainer'>
		<h3>收到！</h3>
		<p>您已完成注册，请下载APP登录！</p>
		<button  class="btn btn-positive btn-block">下载蜜柚接单APP</button>
	</div>	
</template>