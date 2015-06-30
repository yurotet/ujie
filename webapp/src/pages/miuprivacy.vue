<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');

	var View = BasePage.extend({
		title: '蜜柚隐私协议',
		
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
			<h4>隐私协议</h4>
		</div>
		<p class="miu-text-p">蜜柚旅行公司依据本协议的规定提供服务，本协议具有合同效力。您必须完全同意以下所有条款并完成个人资料的填写，才能保证享受到更好的蜜柚旅行客服服务。您使用服务的行为将视为对本协议的接受，并同意接受本协议各项条款的约束。</p>
		<p class="miu-text-p">用户必须合法使用网络服务，不作非法用途，自觉维护本网站的声誉，遵守所有使用网络服务的网络协议、规定、程序和惯例。</p>
		<p class="miu-text-p">为更好的为用户服务，用户应向本网站提供真实、准确的个人资料，个人资料如有变更，应立即修正。如因用户提供的个人资料不实或不准确，给用户自身造成任何性质的损失，均由用户自行承担。</p>
		<p class="miu-text-p">尊重个人隐私是蜜柚旅行公司的责任，蜜柚旅行公司在未经用户授权时不得向第三方（蜜柚旅行公司控股或关联、运营合作单位除外）公开、编辑或透露用户个人资料的内容，但由于政府要求、法律政策需要等原因除外。在用户发送信息的过程中和本网站收到信息后，本网站将遵守行业通用的标准来保护用户的私人信息。但是任何通过因特网发送的信息或电子版本的存储方式都无法确保100%的安全性。因此，本网站会尽力使用商业上可接受的方式来保护用户的个人信息，但不对用户信息的安全作任何担保。</p>
		<p class="miu-text-p">本网站有权在必要时修改服务条例，本网站的服务条例一旦发生变动，将会在本网站的重要页面上提示修改内容，用户如不同意新的修改内容，须立即停止使用本协议约定的服务，否则视为用户完全同意并接受新的修改内容。根据客观情况及经营方针的变化，本网站有中断或停止服务的权利，用户对此表示理解并完全认同。
		本保密协议的解释权归蜜柚旅行公司所有。</p>
		
		<div class="miu-text-end">
			<p>蜜柚旅行公司</p>
			<p>2004年09月</p>
		</div>
	</div>	
</template>