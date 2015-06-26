<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');

	var View = BasePage.extend({
		title: '考试结果',
		data: function() {
			return {
				isPass:false
			}
		},
		methods: {
			onPass:function() {

			},
			onFail:function() {				
			}
		},
		created: function() {
			
		},
		resume:function() {
			this.$data.isPass = this.getParam('r');			
		},
		pause:function() {

		}

	});

	module.exports = View;
</script>

<style>
	.regHeader , .resContainer{
		text-align: center;
	}
	.resContainer h3 {
		margin:25px;
	}
	.resContainer p {
		font-size: 16px;
		margin:40px;
	}	
</style>

<template>
	<div class="regHeader">
		<img src="logo.png"></img>
	</div>

	<div class='resContainer' style = "display:{{isPass=='1'? 'block':'none'}}">
		<h3 class='resultSummary'>太厉害了，考试通过！</h3>
		<p>恭喜您，成功通过考试，成为蜜柚小青，快去下载蜜柚接单APP开始接单了！</p>
		<a  href="http://m.miutour.com/qrcode/index.html"  class="btn btn-positive btn-block">下载蜜柚接单APP</a>
	</div>

	<div class='resContainer'  style = "display:{{isPass=='0'? 'block':'none'}}">
		<h3 class='resultSummary'>糗大了，居然没考过！</h3>
		<p>很遗憾，这次考试没通过，不过别气馁，复习一下我们再来一次！</p>		
	</div>

	<div class='resContainer'  style = "display:{{isPass=='3'? 'block':'none'}}">
		<h3 class='resultSummary'>不要急，再复习一下！</h3>
		<p>很遗憾，今天的考试机会已用完，请复习一下，隔天再来考试！</p>		
	</div>
</template>