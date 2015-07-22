<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');
	var nav = require('common/navigator');
	var lockr = require('common/localstorageutil');	
	var steps = require('pages/regSteps');
	var util = require('common/util');
	var Promise = require('promise');

	var View = BasePage.extend({
		title: '提交审核',
		data:function(){ 
			return {
				curStep:5,
				name: lockr.get('user').realname
			}
		},	
		methods: {
			getPostUserInfo : function() {
				var infoTransList = lockr.get('infoTransList'),
					accTransList=  lockr.get('accTransList'),
					countryTransList=  lockr.get('countryTransList'),
					cityTransList = lockr.get('cityTransList');

				var transList = util.flatten([infoTransList, accTransList,countryTransList,cityTransList]);

				var getText = function(value) {
					for ( var i =0;i < transList.length; i++) {
						if (transList[i].value == value)
							return transList[i].text;
					}				
				}

				var user = lockr.get('user'), 
					retObj = {};
				
				retObj.name= user.realname;
				retObj.sex = getText(user.sex);
				retObj.age = user.age;
				retObj.country = getText(user.country);
				retObj.city = getText(user.city);
				retObj.address = user.address;
				retObj.mobile = user.mobile;
				retObj.email = user.mailBox;
				retObj.weixin = user.wechat;
				retObj.tour_guide_certificate = getText(user.hasGuideCer);
				retObj.drive_age = getText(user.drivingExp);
				retObj.work_age = getText(user.workingExp);
				retObj.pay_type = getText(user.payType) ;
				retObj.alipay = user.alipayAcc;
				retObj.paypal = user.paypalAcc;
				retObj.bank_user =user.accName;
				retObj.bank_name =  user.bankName;
				retObj.bank_code = user.cardNo;

				return retObj;
			},

			getPostPics:function(){
				var user = lockr.get('user'), retObj = {};

				retObj.passport_pic = user.passportPic || '';
				retObj.car_pic=  'none';
				retObj.insurance_pic = 'none';
				retObj.insurance_pic2 = 'none';
				retObj.tourcard_pic = user.guidePic || '';
				retObj.driver_pic = user.licensePic || '';

				return retObj;
			},

			_uploadUserInfo : function() {
				return new Promise(function (resolve, reject) {
					$.ajax({	 
					  type:'POST',				  
					  url: '/api/info', 
					  // data to be added to query string:
					  data: this.getPostUserInfo(),
					  // type of data we are expecting in return:
					  dataType: 'json',
					  timeout: 10000,
					  context: this,
					  success: function(res){alert('bsdfd12312');alert(JSON.stringify(res))
					  	if( res.err_code==0) {					  		 
					  		resolve();					  		
					  	} else {						  		
					  		reject(res.data[0].err_msg);						  		
					  	}
					    
					  },
					  complete:function() {
					  					  	
					  },
					
					  error: function(a){alert(JSON.stringify(a))
					   	reject();
					  }
				})
				}.bind(this));
			},
			
			_uploadPics :function() {
				return new Promise(function(resolve, reject) {
					$.ajax({
						  type:'POST',				  
						  url: '/api/images', 
						  data: this.getPostPics(),				 
						  dataType: 'json',
						  timeout: 10000,
						  context: this,
						 success: function(res){	alert(JSON.stringify(res)); 	 
						  	if(res.err_code==0){
						  		resolve();
						  	} else {	
						  		if (res.data.length) {
						  			reject(res.data[0].err_msg);
						  		} else {
						  			reject();
						  		}		  								  		
						  	}
						    
						  },
						  complete:function() {
						  },
						
						  error: function(){
						   	reject();
						  }
					});
				}.bind(this));
			},

			onSubmit: function() {								
				this.showLoading();							
alert('dgsfds');
				Promise.all([this._uploadUserInfo(), this._uploadPics()]).then(function(){
					this.hideLoading();alert('ks');
					nav.goTo('downloadAPP?s=ing');					
				}.bind(this),function(msg){alert('12312');
					this.hideLoading();
					this.showToast(msg,true);
				}.bind(this));							
			},

			onPre :function() {
				nav.goTo('register?s=true');
			},
			setHeader:function() {
				// $('.stepInfo').text('确认提交');
				// var selText = '.stepsContainer.index1 .step1' ;
								
				// var ela=$(selText+' a'),
				// 	eltext=$(selText+ ' .text');		
		 		
		 	// 	ela.css('width','170px');	  		
		  // 		ela.css('background-color','#77c2a5');

		  // 		eltext.css('display','inline-block');
		  // 		eltext.css('opacity','1');	
			}		
		},
		created: function() {			
			
		},
		resume:function() {
			this.setHeader();	
			if (!lockr.get('isRegLegal')) {
				nav.goTo('notfound');
				return;
			}

		}
	});

	module.exports = View;
</script>

<style>
	.regHeader {
		text-align: center;
	}
	.reg-name {
		font-weight: bold;
		font-size: 18px;
	}
	.confirmMsgContainer {
		padding:20px;
	}
	.confirmMsgContainer p {
		font-size:16px;
	}

	#modifyInfo {
		display: 'inline-block';
		width : 35%;
	}
	#regSubmit {
		display: 'inline-block';
		width: 60%;
		float: right;

	}
</style>

<template>
	<div v-component="view/regSteps" v-with="step:curStep"></div>
	<div class='confirmMsgContainer'>
		<p>
			<span class="reg-name">{{name}}</span>，请确认您填写的资料真实有效，提交注册后，客服将在2个工作日内联系您, 请保持您的联系方式畅通！
		</p>
		
	</div>	

	<button id="regSubmit" class="btn btn-positive btn-block"  v-on="click: onSubmit">提交注册</button>
	<button id="modifyInfo" class="btn btn-nagtive btn-block" v-on="click: onPre"> 重新修改资料</button>
</template>