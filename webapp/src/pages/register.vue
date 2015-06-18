<script>
	var BasePage = require('common/basepage');	
	var Promise = require('promise');
	var nav = require('common/navigator');
	var steps = require('pages/regSteps');
	var lockr = require('common/localstorageutil');

	var View = BasePage.extend({
		title: '我的认证',
		watch: {
			    'user.country': function (val) {
			      	this.$data.cityList  = this.$data.allCityList[val];			      	
			      	this.$data.user.city= this.$data.cityList[0].value;
			    }
		  },
		data: function() {			
			return {
				curStep:4,	

				allCityList:{},
				countryList:[],
				cityList:[],
				
				sexList:[{
					value:'male',
					text: '男'
				},{
					value:'female',
					text:'女'}],

				yesnoList:[{
					value:'no',
					text: '无'
				},{
					value:'yes',
					text: '有'
				}],

				yearRangeList:[{
					value:'1-3',
					text: '1-3年'
				},{
					value:'3-5',
					text: '3-5年'
				},{
					value:'5+',
					text:'5年以上'
				}],
				
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
				// lockr.set('user', this.$data.user);				
				// this.checkSubmitBtn();
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
						  		var ctyList = [];
						  		$.each(res.data, function(key,val) {					  			
						  			ctyList.push({
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

						  		this.$data.countryList = ctyList;	
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
				nav.goTo('picupdate');				
			},


			setHeader:function() {
				var selText = '.stepsContainer.index4 .step4' ;			

				var el = $(selText),
					ela=$(selText+' a'),
					eltext=$(selText+' .text');
				
				el.css('padding','3px');
		 		el.css('margin-top','0');
		 		
		 		ela.css('width','100px');
		  		ela.css('height','60px');
		 		ela.css('line-height','60px');
		  		ela.css('background-color','#77c2a5');

		  		eltext.css('display','inline-block');
		  		eltext.css('opacity','1');
			},

			initData:function() {
				$.each(lockr.get('user'), function(key,val) {					
					if (val != '') {
						this.$data.user[key]=val;
					}							
				}.bind(this));
				
				this.checkSubmitBtn();
			}			
		},

		created: function() {			
			this._loadCountryInfo().then(this.initData);
		},

		resume: function() {
			this.setHeader();			
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
			<input type="text" v-on="input:onInputChange" placeholder="真实姓名 (必填)" v-model="user.realname"></input>			
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

<button id="userInfoBtn" class="btn btn-positive btn-block" disabled="disabled" v-on="click: onSubmit">下一步, 上传认证照片</button>

</template>