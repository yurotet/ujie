<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');
	var nav = require('common/navigator');
	var config = require('config');	
	var steps = require('pages/regSteps');
	var lockr = require('common/localstorageutil');	

	var View = BasePage.extend({
		title: '注册',
		data: function() {
			return {
				curStep:1,				
				username:'',
				realname:'',
				pwd:'',	
				mobile:'',
				confirmPwd:'',
				recCode:''
			};
		},

		methods: {
			setHeader:function() {
				$('.stepInfo').text('创建账号');	
			},
			checkSubmitBtn: function() {
				var disabled =!this.$data.realname || !this.$data.mobile ||   !this.$data.username || !this.$data.pwd  || (this.$data.pwd && (this.$data.pwd != this.$data.confirmPwd));				
				
				var regBtn = $('#regBtn');
				
				if (disabled) {
					regBtn.attr('disabled','disabled');
				}else {
					regBtn.removeAttr('disabled');					
				}
				
			},
			onUserInput:function(){
				this.checkSubmitBtn();
			},
			onPwdInput:function() {				
				this.$data.confirmPwd='';
				$('#confirmPwdInput').css('background-color','#FFFFFF');
				this.checkSubmitBtn();
			},

			onConfirmPwdInput :function(){
				var input = $('#confirmPwdInput');
				if  (this.$data.pwd != this.$data.confirmPwd){					
					input.css('background-color','#FFF2F2');
				}else {					
					input.css('background-color','#FFFFFF');
				}

				this.checkSubmitBtn();
			},
			onSubmit: function() {
				// save new user
				var  user=  lockr.get('user') || {};
				user.realname = this.$data.realname;				
				lockr.set('user', user);

				this.showLoading();						
				
				$.ajax({	 
					  type:'POST',				  
					  url: '/api/register', 
					  // data to be added to query string:
					  data: { username: this.$data.username,
					  	passwd:this.$data.pwd,
					  	name:this.$data.realname,
					  	mobile:this.$data.mobile,
					  	recode:this.$data.recCode},
					  // type of data we are expecting in return:
					  dataType: 'json',
					  timeout: 10000,
					  context: this,
					  success: function(res){					  	
					  	if(! res.err_code || res.err_code==0){
					  		nav.goTo('register?s=true');
					  	} else {					  		
					  		this.showToast(res.err_msg,true);
					  	}
					    
					  },
					  complete:function() {
					  	this.hideLoading();					  	
					  },
					
					  error: function(xhr, type){
					   	
					  }
				})									
			},

			onAgreeClick:function() {

			}			
		},
		created: function() {									
				
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
	.red {
		color: #f00;
	}
	.dbtap {
		width: 100px;
		height: 100px;
		background-color: blue;
	}

	#linkSec a{
		text-decoration:underline;
	}

	#linkSec{
		text-align: center;
		margin-top: 20px;
	}
	.regHeader {
		text-align: center;
	}
</style>

<template>	
	<!-- <div class="regHeader">
		<img src="logo.png"></img>
	</div> -->
	<div v-component="view/regSteps" v-with="step:curStep"></div>
	  <div class="driver-reg">
		  <form class="input-group">
			    <div class="input-row">
				      <input type="text"  v-on="input:onUserInput" placeholder="用户名 (3-16位字母, 数字或汉字)" v-model="username">
			    </div> 
			    <div class="input-row">
				      <input type="text"  v-on="input:onUserInput" placeholder="真实姓名" v-model="realname">
			    </div>			   
			    <div class="input-row">
				      <input type="password" v-on="input:onPwdInput" placeholder="设置密码 (大于6位)" v-model="pwd">
			    </div>
			    <div id="confirmPwdInput" class="input-row">				      
				      <input type="password" v-on="input:onConfirmPwdInput" placeholder="确认密码" v-model="confirmPwd">
			    </div> <div class="input-row">
				      <input type="text"  v-on="input:onUserInput" placeholder="手机号" v-model="mobile">
			    </div>
			    <div class="input-row">
				      <input type="text" placeholder="推荐码 (可选)" v-model="recCode">
			    </div>
		    </form>
	  
		    <button  id="regBtn" class="miu-subBtn btn btn-positive btn-block"  disabled="disabled"  v-on="click: onSubmit">下一步</button>	
		    <div  id="linkSec"><p>注册即表示同意<a href="http://g.miutour.com/help/gagreement.html" target="_blank">蜜柚私导协议</a></p></div>    	
	  </div>	 
</template>