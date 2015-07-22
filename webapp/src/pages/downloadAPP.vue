<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');
	var  lockr = require('common/localstorageutil');
	var nav = require('common/navigator');


	var View = BasePage.extend({
		title: '下载APP',
		data: function() {
			var user = lockr.get('user'), realName;

			var realname = user? user.realname: '';
			var refuseDes = lockr.get('refuse_des') || '';

			return {
				realname:realname,
				refuse_des:refuseDes,	
				success:false,
				fail:false,
				ing:false			
			}
		},
		
		methods: {
			modify:function() {
				nav.goTo('register?s=true')
			}

		},
		created: function() {

		},
		resume:function() {
			var status = this.getParam('s');
			this.$data.success = status == 'success';
			this.$data.fail = status == 'fail';
			this.$data.ing = status == 'ing';			
		}
	});

	module.exports = View;
</script>

<style>
	.regHeader , .cntContainer{
		text-align: center;
	}
	.cntContainer h4{
		margin: 15px;
margin-left: 0px;
margin-right: 0px;
	}
	.cntContainer p {
		font-size: 16px;
		margin:10px;
		margin-bottom: 30px
	}
</style>

<template>
	<div v-show="success">
		<div class="regHeader">
			<img src="finish.png" alt="注册信息审核状态"></img>
		</div>

		<div class='cntContainer'>		
			<h4>{{realname}}，您已成功通过审核！</h4>
			<p>下载蜜柚接单APP接可以开始接单了</p>
			<a  href="http://m.miutour.com/qrcode/index.html"  class="btn btn-positive btn-block">下载蜜柚接单APP</a>
		</div>	
		
	</div>

	<div v-show="fail">
		<div class="regHeader">
			<img src="error.png" alt="注册信息审核状态"></img>
		</div>

		<div class='cntContainer'>		
			<h4>{{realname}}，您的注册信息还不完整</h4>
			<p>继续完善注册信息就可以重新提交审核了</p>
			<p>{{refuse_des}}</p>
			<button  v-on="click:modify"  class="btn btn-positive btn-block">完善注册信息</button>
		</div>	
	</div>

	
	<div v-show="ing">
		<div class="regHeader">
			<img src="wait.png" alt="注册信息审核状态"></img>
		</div>

		<div class='cntContainer'>		
			<h4>{{realname}}，您的注册信息正在审核中</h4>
			<p>有审核结果了我们会第一时间通知您哦</p>
		</div>			
	</div>	
</template>