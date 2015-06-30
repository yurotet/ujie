<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');

	var View = BasePage.extend({
		title: '关于蜜柚',
		
		methods: {
			
		},
		created: function() {
		}
		
	});

	module.exports = View;
</script>

<style>
	.regHeader {
		text-align: center;
	}
	/*.cntContainer h3 {
		margin:25px;
	}*/
	.cntContainer {
		font-size: 16px;
		margin:40px;
	}
	.miu-text-end {
		float:right;
	}
	.miu-text-p {
		text-indent:25px;
	}
	.cntContainer .miu-title {
		text-align: center;
		margin-bottom: 20px;
	}

</style>

<template>
	<div class="regHeader">
		<img src="logo.png"></img>
	</div>

	<div class='cntContainer'>
		<div class="miu-title">
			<h4>关于蜜柚</h4>
		</div>
		<p class="miu-text-p">MIU TOUR蜜柚旅行创立于2014年，旨在让用户真正享受轻松自在、趣味非凡的海外私人旅行！MIU TOUR致力于在游客与境外终端导游之间建立直接对接的P2P平台，让用户享受到定制化深度旅游的同时，节省大量的时间、精力和成本；也为有能力的终端导游创造了可以实现差异化服务的空间，从而提供更具当地特色的景点线路和旅游项目提供给用户。MIU TOUR，寻觅最诱人的海外本地旅行！</p>						
	</div>	
</template>