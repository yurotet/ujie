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
		<p>您的注册认证信息已提交到蜜柚旅行，快下载蜜柚接单APP查看认证状态吧。</p>
		<button  class="btn btn-positive btn-block">下载蜜柚接单APP</button>
	</div>	
</template>