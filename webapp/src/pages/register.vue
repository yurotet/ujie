<script>
	var BasePage = require('common/basepage');	
	var Promise = require('promise');
	var nav = require('common/navigator');
	var steps = require('pages/regSteps');
	var lockr = require('common/localstorageutil');
	var util = require('common/util');

	var REG_STATUS= {		
		NOT_REGED:1,
		REG_IN_PROGRESS:2,
		READY_FOR_REG:3,
		REG_FAILED: 4,
		REG_SUCCESS:5,
		REG_NOT_LOGIN:6

	};

	var View = BasePage.extend({
		title: '我的认证',
		watch: {
			    'user.country': function (val) {
			      	this.$data.cityList  = this.$data.allCityList[val];			      	
			      	this.$data.user.city= this.$data.cityList[0].value;
			    }
		  },
		data: function() {
			
			var sexList = [{
				value:'male',
				text: '男'
			},{
				value:'female',
				text:'女'}],

			yesnoList =[{
				value:'no',
				text: '无'
			},{
				value:'yes',
				text: '有'
			}],

			yearRangeList =[{
				value:'1-3',
				text: '1-3年'
			},{
				value:'3-5',
				text: '3-5年'
			},{
				value:'5+',
				text:'5年以上'
			}];
		
			var listToSave = util.flatten([sexList, yesnoList, yearRangeList]);
			lockr.set('infoTransList',listToSave );		

			return {
				curStep:2,	

				allCityList:{},
				countryList:[],
				cityList:[],
				
				sexList:sexList,
				yesnoList:yesnoList,
				yearRangeList:yearRangeList,
				
				user:{					
					sex:'male',
					hasGuideCer:'no',
					drivingExp:'1-3',
					workingExp:'1-3',
					city:'',
					age:'',
					realname:'',
					country:'',
					address:'',
					mobile:'',
					wechat:'',					
					mailBox:'',
				}		
			};
		},
		
		methods: { 			
			checkSubmitBtn:function(){					
				var disabled  = !this.$data.user.realname || !this.$data.user.age || !this.$data.user.mobile || !this.$data.user.mailBox || ! this.$data.user.wechat;						

				var btn  = $('#userInfoBtn');

				if (disabled) {
					btn.attr('disabled','disabled');
				} else {
					btn.removeAttr('disabled');
				}
			},

			onInputChange:function() {				
				var savedUser = lockr.get('user') || {};				
				$.each(this.$data.user,function(key, val) {
					savedUser[key] = val;
				});

				lockr.set('user', savedUser);

				this.checkSubmitBtn();
			},
			
			_loadCountryInfo:function() {
				return new Promise(function(resolve, reject) {
					this.showLoading();
		  			$.ajax({
						  type:'GET',				  
						  url: '/api/tags', 				 
						  dataType: 'json',
						  timeout: 10000,
						  context: this,
						  success: function(res){  
						  	if(res.err_code==0){
						  		var countryList = [];
						  		$.each(res.data, function(key,val) {					  			
						  			countryList.push({
						  				value:key,
						  				text:val.name
						  			});					  			

						  			var cList = [];
						  			$.each(val.children,function(cKey,cVal) {
						  				cList.push({
						  					value:cKey,
						  					text:cVal
						  				});					  				
						  			});
						  									  			
						  			this.$data.allCityList[key] =cList;
						  		}.bind(this));

						  		// save value/text mappings for cities
						  		var cityTrans = [];
						  		$.each(this.$data.allCityList,function (key, value) {
						  			cityTrans = util.flatten([cityTrans, value]);
						  		})
						  		lockr.set('cityTransList', cityTrans);

						  		// save value/text mappings for countries
						  		lockr.set('countryTransList', countryList);


						  		this.$data.countryList = countryList;	
						  		this.$data.user.country = this.$data.countryList [0].value;
						  		resolve();			  		
						  	} else {					  		
						  		this.showToast(res.err_msg,true);
						  		reject();
						  	}
						    
						  },
						  complete:function() {
						  	this.hideLoading();					  	
						  },
						
						  error: function(xhr, type){
						   	reject();
						  }
					})	

				}.bind(this));
				
			},
					
			onSubmit: function() {
				lockr.set('isRegLegal',true);
				nav.goTo('picupdate');				
			},


			setHeader:function() {
				$('.stepInfo').text('填写基本信息');
				// var selText = '.stepsContainer.index4 .step4 ' ;			

				// var el = $(selText),
				// 	ela=$(selText+' a'),
				// 	eltext=$(selText+' .text');
				
				// el.css('padding','3px');
		 	// 	el.css('margin-top','0');
		 		
		 	// 	ela.css('width','100px');
		  // 		ela.css('height','60px');
		 	// 	ela.css('line-height','60px');
		  // 		ela.css('background-color','#77c2a5');

		  // 		eltext.css('display','inline-block');
		  // 		eltext.css('opacity','1');
			},

			initData:function() {
				$.each(lockr.get('user'), function(key,val) {					
					if (val != '') {
						this.$data.user[key]=val;
					}							
				}.bind(this));
				
				this.checkSubmitBtn();
			},

			_loadAuthStauts:function() {
				return new Promise(function(resolve, reject) {					
					this.showLoading(); 
					 $.ajax({   
					            type:'GET', 
					            url: '/api/info', 					          
					            dataType: 'json',
					            timeout: 10000,
					            context: this,
					            success: function(body){  					            	
					              if (body.err_code == 0 ) {	
					              	
					              // resolve(REG_STATUS.READY_FOR_REG);	
					              // body.data.guide_auth=1;		              
					               	switch (body.data.guide_auth) {
					               		case '1': 	// 审核通过
					               			resovle(REG_STATUS.REG_SUCCESS);
					               		break;
					               		case '3': 	// 审核失败
					               			resolve(REG_STATUS.REG_FAILED, body.data.refuse_reason);
					               		break;
					               		case '2':             // 审核中
					               			resolve(REG_STATUS.REG_IN_PROGRESS);
					               		break;

					               		case '0'	:	//待审核
					               			resolve(REG_STATUS.READY_FOR_REG);
					               		break;
					               		default:
					               			resolve(REG_STATUS.NOT_REGED);
					               		break;					               		
					               	}					               	

					              } else {	
					              	resolve(REG_STATUS.NOT_REGED);					                  
					              }                          
					            }.bind(this),
					            complete:function() {
					                          this.hideLoading();
					            },
					          
					            error: function(err){
					              reject();
					            }
					        }) 
					}.bind(this));
			},
			

			 checkRegStatus : function() {
			 	this.showLoading();
			 	this._loadAuthStauts().then(function(statusCode,extra){ 
			 		this.hideLoading();console.log(statusCode);
			 		switch (statusCode) {
			 			case  REG_STATUS.NOT_REGED: 	
			 				nav.goTo('newUser');
			 			break;
			 			case REG_STATUS.REG_SUCCESS: 		
			 				nav.goTo('downloadAPP?s=success');
			 			break;	
			 			case REG_STATUS.REG_FAILED:
			 				lockr.set('refuse_des', extra);
			 				nav.goTo("downloadAPP?s=fail");
			 			break;
			 			case REG_STATUS.READY_FOR_REG:
			 				nav.goTo("register");
			 			break;
			 			case REG_STATUS.REG_IN_PROGRESS:
			 				nav.goTo("downloadAPP?s=ing");
			 			break;
			 			default:			 				
			 				nav.goTo('notfound');
			 			break;
			 		}
			 	}.bind(this)).catch(function(err) {			 		
			 		this.hideLoading();
			 		nav.goTo('notfound');
			 	}.bind(this));
			 }	
		},
		
		created: function() {
			lockr.set('isRegLegal', false);
			this._loadCountryInfo().then(this.initData);			
		},

		resume: function() {
			this.setHeader();
			if (!this.getParam('s')) {
				this.checkRegStatus();					
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
		color:#aaaaaa;
	}
	.userInfo select {
		margin-top: 5px;
		width:65%;
		font-size:16px;
	}

	.userInfo .input-row label.more{
		font-size: 14px;
	}
</style>

<template>

<div v-component="view/regSteps" v-with="step:curStep"></div>
  <div class='userInfo'>
  	 <form class="input-group">
  		 <div class="input-row" >			
			<label>姓名</label>	
			<input type="text" v-on="input:onInputChange" placeholder="请填写真实姓名 (必填)" v-model="user.realname"></input>			
		</div>
  	 	<div class="input-row">	
			<label>性别</label>
			<select   v-on="change:onInputChange" options="sexList" v-model="user.sex"></select>			
		</div>
  		<div class="input-row">	
  			<label>年龄</label>
			<input   v-on="input:onInputChange" type="number"  min="18"  max="60" placeholder="年龄 (必填)" v-model="user.age"></input>
		</div>
		
		<div class="input-row">	
			<label>地址</label>		
			<input  v-on="input:onInputChange" type="text"  placeholder="地址 (必填)" v-model="user.address"></input>	
		</div>

		<div class="input-row">	
			<label>手机</label>	
			<input  v-on="input:onInputChange" type="text"  placeholder="手机 (必填)" v-model="user.mobile"></input>	
		</div>

		<div class="input-row">	
			<label>邮箱</label>	
			<input v-on="input:onInputChange" type="text"  placeholder="邮箱 (必填)" v-model="user.mailBox"></input>	
		</div>

		<div class="input-row">	
			<label>微信</label>	
			<input v-on="input:onInputChange" type="text"  placeholder="微信 (必填)" v-model="user.wechat"></input>	
		</div>

		<div class="input-row">
			<label>国家</label>
			<select   v-on="change:onInputChange" options="countryList"   v-model="user.country"></select>	
		</div>
		<div class="input-row">	
			<label>城市</label>		
			<select  v-on="change:onInputChange" options="cityList"  v-model="user.city"></select>	
		</div>

		<div class="input-row">	
			<label >导游证</label>		
			<select  v-on="change:onInputChange" options="yesnoList"   v-model="user.hasGuideCer"></select>	
		</div>		

		<div class="input-row">	
			<label>驾龄</label>		
			<select  v-on="change:onInputChange" options="yearRangeList"   v-model="user.drivingExp"></select>	
		</div>

		<div class="input-row">	
			<label class="more">从业时间</label>		
			<select  v-on="change:onInputChange" options="yearRangeList"   v-model="user.workingExp"></select>	
		</div>			
	</form>
</div>

<button id="userInfoBtn" class="btn btn-positive btn-block" disabled="disabled" v-on="click: onSubmit">下一步</button>

</template>