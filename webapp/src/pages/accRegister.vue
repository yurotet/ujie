<script>
	var BasePage = require('common/basepage');		
	var nav = require('common/navigator');
	var steps = require('pages/regSteps');
	var lockr = require('common/localstorageutil');	
	var util = require('common/util');

	var View = BasePage.extend({
		title: '结算账户',

		data: function() {

			var payTypeList=[{
				value:'alipay',
				text: '支付宝 '
			},{
				value:'bank',
				text: '银行'
			},{
				value:'paypal',
				text: 'paypal'
			}];
						
			lockr.set('accTransList',payTypeList );	

			return {
				curStep:2,	
				
				payTypeList:payTypeList,

				user:{									
					payType:'alipay',					
					alipayAcc:'',
					bankName:'',
					paypalAcc:'',
					cardNo:'',				
					accName:''
				}		
			};
		},
		
		methods: { 			
			checkSubmitBtn:function(){					
				var disabled  = true;

				switch (this.$data.user.payType) {
					case 'alipay':
						disabled = (this.$data.user.payType == 'alipay' && !this.$data.user.alipayAcc);				
					break;
					case 'bank':
						disabled = (this.$data.user.payType == 'bank' && (!this.$data.user.bankName || !this.$data.user.cardNo || !this.$data.user.accName));						
					break;
					case 'paypal':
						disabled  = (this.$data.user.payType =='paypal' && (!this.$data.user.paypalAcc))
					break;
				}			
			
				var btn  = $('#accSubBtn');

				if (disabled) {
					btn.attr('disabled','disabled');
				} else {
					btn.removeAttr('disabled');
				}
			},

			onInputChange:function() {
				lockr.set('user', this.$data.user);				
				this.checkSubmitBtn();
			},
						
					
			onSubmit: function() {				
				nav.goTo('confirmSubmit');		
			},

			onPre:function() {
				nav.goTo('picupdate');
			},


			setHeader:function() {
				var selText = '.stepsContainer.index2 .step2' ;
								
				var ela=$(selText+' a'),
					eltext=$(selText+ ' .text');		
		 		
		 		ela.css('width','170px');	  		
		  		ela.css('background-color','#77c2a5');

		  		eltext.css('display','inline-block');
		  		eltext.css('opacity','1');	
			},

			initData:function() {					
				$.each(lockr.get('user'), function(key,val) {
					console.log(val);
					if (val != '') {
						this.$data.user[key]=val;
					}							
				}.bind(this));
				
				setTimeout(this.checkSubmitBtn,0);
				
			}			
		},

		created: function() {
			this.initData();
		},

		resume: function() {
			this.setHeader();
			if (!lockr.get('isRegLegal')) {
				nav.goTo('notfound');
			}		
		},
		pause:function(){

		}			
	});

	module.exports = View;
</script>

<style>		
	.userInfo .input-row input{
		width: 65%;
		font-size: 18px;
	}
	.userInfo .input-row label{
		font-size: 14px;
		color:#666666;
	}
	.userInfo select {
		margin-top: 5px;
		width:65%;
		font-size:16px;
	}
	#accSubPreBtn {
		display: 'inline-block';
		width : 35%;
	}
	#accSubBtn {
		display: 'inline-block';
		width: 60%;
		float: right;

	}
</style>

<template>

<div v-component="view/regSteps" v-with="step:curStep"></div>
  <div class='userInfo'>
  	 <form class="input-group">  		

		<div class="input-row">	
			<label class="more">结算方式</label>		
			<select  v-on="change:onInputChange" options="payTypeList"   v-model="user.payType"></select>	
		</div>

		<div class="input-row" style="display:{{user.payType == 'alipay'? 'block':'none'}}">	
			<label class="more">支付宝</label>	
			<input v-on="input:onInputChange" type="text"  placeholder="支付宝账号 (必填)" v-model="user.alipayAcc"></input>	
		</div>

		<div class="input-row" style="display:{{user.payType == 'bank'? 'block': 'none'}}">	
			<label class="more">开户银行</label>	
			<input v-on="input:onInputChange" type="text"  placeholder="开户银行名称 (必填)" v-model="user.bankName"></input>	
		</div>

		<div class="input-row" style="display:{{user.payType == 'bank'? 'block': 'none'}}">	
			<label class="more">账户名称</label>	
			<input v-on="input:onInputChange" type="text"  placeholder="账户名称 (必填)" v-model="user.accName"></input>	
		</div>

		<div class="input-row" style="display:{{user.payType == 'bank'? 'block': 'none'}}">	
			<label class="more">银行卡号</label>	
			<input v-on="input:onInputChange" type="text"  placeholder="银行卡号 (必填)" v-model="user.cardNo"></input>	
		</div>

		<div class="input-row" style="display:{{user.payType == 'paypal'? 'block': 'none'}}">	
			<label>Paypal</label>	
			<input v-on="input:onInputChange"  type="text"  placeholder="Paypal账号 (必填)" v-model="user.paypalAcc"></input>	
		</div>			
	</form>
</div>

<button id="accSubBtn" class="btn btn-positive btn-block" disabled="disabled" v-on="click: onSubmit">下一步, 提交审核</button>
<button id="accSubPreBtn" class="btn btn-nagtive btn-block" v-on="click: onPre">上一步</button>

</template>