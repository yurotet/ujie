<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');
	var  lockr = require('common/localstorageutil')

	var View = BasePage.extend({
		title: '下载APP',
		data: function() {
			var user = lockr.get('user'), realName;
			var realname = user? user.realname: '';		
			return {
				realname:realname
			}
		},
		
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
		<h3>恭喜{{realname}}，您已完成注册，请下载APP登录！</h3>
		<a  href="http://m.miutour.com/qrcode/index.html" target="_blank" class="btn btn-positive btn-block">下载蜜柚接单APP</a>
	</div>	
</template>