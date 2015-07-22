<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');
	var nav = require('common/navigator');

	var View = BasePage.extend({
		title: '司导指南',
		data: function() {
			
		},
		methods: {
			c1:function() {
				nav.goTo('guidedetails?c=1')
			},
			c2:function() {
				nav.goTo('guidedetails?c=2')
			},
			c3:function() {
				nav.goTo('guidedetails?c=3')
			},
			c4:function() {
				nav.goTo('guidedetails?c=4')
			},
			c5:function() {
				nav.goTo('guidedetails?c=5')
			}
		},
		created: function() {
			
		},
		resume:function() {
			// this.$data.isPass = this.getParam('r');			
		},
		pause:function() {

		}

	});

	module.exports = View;
</script>

<style>
	.header {
		text-align: center;
		margin-top:20px;
		margin-bottom:20px;
	}
</style>

<template>
<h2 class="header">司导指南</h2>
<button v-on="click:c1" class="btn btn-negative btn-block">服务标准</button>
<button v-on="click:c2" class="btn btn-negative btn-block">派单规则</button>
<button v-on="click:c3" class="btn btn-negative btn-block">评级规则</button>
<button v-on="click:c4" class="btn btn-negative btn-block">处罚规则</button>
<button v-on="click:c5" class="btn btn-negative btn-block">常见问题</button>
</template>